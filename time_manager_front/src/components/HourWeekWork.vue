<script setup>
import { ref, onMounted, computed, watch } from 'vue';
import { Chart as ChartJS, CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend } from 'chart.js';
import { Bar } from 'vue-chartjs';
import { getWorkingTimesUserId } from '@/services/workingTimeService';

ChartJS.register(CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend);

const props = defineProps({
  userId: {
    type: String,
    required: true
  },
  isAdmin: {
    type: Boolean,
    default: false
  },
  users: {
    type: Array,
    required: true
  },
  nightWorkStartHour: {
    type: Number,
    default: 22
  },
  nightWorkEndHour: {
    type: Number,
    default: 6
  },
  maxRegularHours: {
    type: Number,
    default: 35
  }
});

const { users } = props;

const selectedUserId = ref(props.userId);

const updateUserId = (event) => {
  const newUserId = event.target.value;
  selectedUserId.value = newUserId;
  localStorage.setItem('userId', newUserId);
};

const workingTimes = ref([]);

function formatDate(date) {
  return date.toISOString().split('T')[0] + 'T00:00:00';
}

const today = new Date();
const endOfWeek = new Date(today);
endOfWeek.setDate(today.getDate() - today.getDay() + 7);
endOfWeek.setHours(23, 59, 59);

const startOfPeriod = new Date(endOfWeek);
startOfPeriod.setDate(endOfWeek.getDate() - 84); // 12 semaines * 7 jours = 84 jours

const start = ref(formatDate(startOfPeriod));
const end = ref(endOfWeek.toISOString().replace('Z', ''));

function calculateHours(start, end, nightStartHour, nightEndHour, maxRegularHours) {
  const startDate = new Date(start);
  const endDate = new Date(end);
  let regularHours = 0;
  let nightHours = 0;
  let overtimeHours = 0;

  let currentTime = startDate.getTime();
  const endTime = endDate.getTime();

  while (currentTime < endTime) {
    const currentHour = new Date(currentTime).getHours();
    const isNightHour = currentHour >= nightStartHour || currentHour < nightEndHour;

    if (isNightHour) {
      nightHours++;
    } else if (regularHours < maxRegularHours) {
      regularHours++;
    } else {
      overtimeHours++;
    }

    currentTime += 3600000; // Add 1 hour (in milliseconds)
  }

  return { regularHours, nightHours, overtimeHours };
}

const chartData = computed(() => {
  const weeklyHours = {};
  const allWeeks = [];

  let currentDate = new Date(startOfPeriod);
  while (currentDate <= endOfWeek) {
    const weekKey = getWeekNumber(currentDate);
    allWeeks.push(weekKey);
    weeklyHours[weekKey] = { regular: 0, night: 0, overtime: 0 };
    currentDate.setDate(currentDate.getDate() + 7);
  }

  workingTimes.value.forEach(wt => {
    const weekKey = getWeekNumber(new Date(wt.start));
    const { regularHours, nightHours, overtimeHours } = calculateHours(
      wt.start,
      wt.end,
      props.nightWorkStartHour,
      props.nightWorkEndHour,
      props.maxRegularHours
    );

    weeklyHours[weekKey].regular += regularHours;
    weeklyHours[weekKey].night += nightHours;
    weeklyHours[weekKey].overtime += overtimeHours;
  });

  const labels = allWeeks;
  const regularData = labels.map(week => weeklyHours[week].regular);
  const nightData = labels.map(week => weeklyHours[week].night);
  const overtimeData = labels.map(week => weeklyHours[week].overtime);

  return {
    labels,
    datasets: [
      {
        label: 'Heures normales',
        data: regularData,
        backgroundColor: 'rgba(75, 192, 192, 0.6)',
      },
      {
        label: 'Heures de nuit',
        data: nightData,
        backgroundColor: 'rgba(54, 162, 235, 0.6)',
      },
      {
        label: 'Heures supplémentaires',
        data: overtimeData,
        backgroundColor: 'rgba(255, 99, 132, 0.6)',
      }
    ]
  };
});

const chartOptions = {
  responsive: true,
  scales: {
    y: {
      beginAtZero: true,
      stacked: true,
      title: {
        display: true,
        text: 'Heures travaillées'
      }
    },
    x: {
      stacked: true,
      title: {
        display: true,
        text: 'Semaine'
      },
      ticks: {
        maxRotation: 90,
        minRotation: 90
      }
    }
  },
  plugins: {
    tooltip: {
      callbacks: {
        title: (tooltipItems) => {
          const weekLabel = tooltipItems[0].label;
          const [year, week] = weekLabel.split('-W');
          return `Semaine ${week} de ${year}`;
        }
      }
    }
  }
};

function getWeekNumber(date) {
  const d = new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate()));
  const dayNum = d.getUTCDay() || 7;
  d.setUTCDate(d.getUTCDate() + 4 - dayNum);
  const yearStart = new Date(Date.UTC(d.getUTCFullYear(),0,1));
  const weekNo = Math.ceil((((d - yearStart) / 86400000) + 1)/7);
  return `${d.getUTCFullYear()}-W${weekNo.toString().padStart(2, '0')}`;
}

onMounted(async () => {
  const storedUserId = localStorage.getItem('userId');
  if (storedUserId) {
    selectedUserId.value = storedUserId;
  }
  if (props.userId) {
    try {
      const data = await getWorkingTimesUserId(props.userId, start.value, end.value);
      workingTimes.value = data;
    } catch (error) {
      console.error('Erreur lors de la récupération des temps de travail:', error);
    }
  } else {
    console.error('User ID not found');
  }
});

watch(selectedUserId, async (newValue) => {
  try {
    const data = await getWorkingTimesUserId(selectedUserId.value, start.value, end.value);
    workingTimes.value = data;
  } catch (error) {
    console.error('Erreur lors de la récupération des temps de travail:', error);
  }
});
</script>

<template>
  <div class="chart-container">
    <h2>Hours worked per week</h2>
    
    <div v-if="props.isAdmin" class="select-container">
      <label for="numberSelect">Select a user : </label>
      <select id="numberSelect" v-model="selectedUserId" >
        <option v-for="user in users" :key="user.id" :value="user.id">
          {{ user.username }}
        </option>Select a user : 
      </select>
    </div>

    <Bar v-if="workingTimes.length > 0" :data="chartData" :options="chartOptions" />
    <p v-else>No working time data available</p>
  </div>
</template>

<style scoped>
.chart-container {
  width: 95%;
  margin: 0 auto;
  text-align: center;
}
</style>