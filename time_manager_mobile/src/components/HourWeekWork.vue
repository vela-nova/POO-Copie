

<template>
  <div class="chart-container">
    <h2>Heures travaillées par semaine</h2>
    
    <div class="select-container">
      <label for="numberSelect">Sélectionnez un numéro :</label>
      <select id="numberSelect" v-model="selectedNumber">
        <option v-for="number in props.users.users.length" :key="number" :value="number">
          {{ number }}
        </option>
      </select>
    </div>

    <Bar v-if="workingTimes.length > 0" :data="chartData" :options="chartOptions" />
    <p v-else>Aucune donnée disponible</p>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import { Chart as ChartJS, CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend } from 'chart.js';
import { Bar } from 'vue-chartjs';
import { getWorkingTimesUserId } from '../services/workingTimeService'; // Assurez-vous que ce chemin est correct

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
  }
});

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

const chartData = computed(() => {
  const weeklyHours = {};
  const allWeeks = [];

  // Générer toutes les semaines de la période
  let currentDate = new Date(startOfPeriod);
  while (currentDate <= endOfWeek) {
    const weekKey = getWeekNumber(currentDate);
    allWeeks.push(weekKey);
    weeklyHours[weekKey] = 0;
    currentDate.setDate(currentDate.getDate() + 7);
  }

  workingTimes.value.forEach(wt => {
    const startDate = new Date(wt.start);
    const endDate = new Date(wt.end);
    const weekKey = getWeekNumber(startDate);
    const hoursWorked = (endDate - startDate) / (1000 * 60 * 60);

    weeklyHours[weekKey] += hoursWorked;
  });

  const labels = allWeeks;
  const data = labels.map(week => weeklyHours[week]);

  return {
    labels,
    datasets: [
      {
        label: 'Heures travaillées par semaine',
        data,
        backgroundColor: 'rgba(75, 192, 192, 0.6)',
      }
    ]
  };
});

const chartOptions = {
  responsive: true,
  scales: {
    y: {
      beginAtZero: true,
      title: {
        display: true,
        text: 'Heures travaillées'
      }
    },
    x: {
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
  if (props.userId.userId) {
    try {
      const data = await getWorkingTimesUserId(props.userId.userId, start.value, end.value);
      workingTimes.value = data.data;
    } catch (error) {
      console.error('Erreur lors de la récupération des temps de travail:', error);
    }
  } else {
    console.error('User ID not found');
  }
});
</script>

<style scoped>
.chart-container {
  width: 95%;
  margin: 0 auto;
  text-align: center;
}
</style>