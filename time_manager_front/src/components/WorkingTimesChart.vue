<script setup>
import { ref, onMounted } from 'vue';
import { Chart, ArcElement, Tooltip, Legend } from 'chart.js';
import { Pie } from 'vue-chartjs';
import { getAllIdWorkingTimes } from '@/services/workingTimeService';

Chart.register(ArcElement, Tooltip, Legend);

const chartData = ref(null);
const chartOptions = ref({
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: {
      position: 'bottom',
      labels: {
        font: {
          size: 14
        },
        usePointStyle: true,
        pointStyle: 'circle',
        padding: 20 
      }
    },
    tooltip: {
      callbacks: {
        label: function(context) {
          return context.label + ': ' + context.formattedValue + '%';
        }
      }
    }
  },
  elements: {
    arc: {
      borderWidth: 0 // Supprime les bordures blanches
    }
  }
});

function formatDate(date) {
  return date.toISOString().split('T')[0] + 'T00:00:00';
}

const today = new Date();

const startOfWeek = new Date(today);
startOfWeek.setDate(today.getDate() - today.getDay() + (today.getDay() === 0 ? -6 : 1));

const endOfWeek = new Date(startOfWeek);
endOfWeek.setDate(startOfWeek.getDate() + 8);
endOfWeek.setHours(0, 0, 0, 0);


const start = ref(formatDate(startOfWeek));
const end = ref(formatDate(endOfWeek));

const fetchWorkingTimes = async () => {
  try {
    const data = await getAllIdWorkingTimes(start.value, end.value);
    processChartData(data);
  } catch (error) {
    console.error('Error in fetchWorkingTimes:', error);
  }
};

const processChartData = (workingTimes) => {
  const userHours = {};
  workingTimes.forEach(wt => {
    const userId = wt.user_id;
    const startTime = new Date(wt.start);
    const endTime = new Date(wt.end);
    const hoursWorked = (endTime - startTime) / (1000 * 60 * 60);
    
    if (userHours[userId]) {
      userHours[userId] += hoursWorked;
    } else {
      userHours[userId] = hoursWorked;
    }
  });
  const labels = Object.keys(userHours).map(id => `User ${id}`);
  const dataValues = Object.values(userHours);

  chartData.value = {
    labels: labels,
    datasets: [{
      backgroundColor: [
        '#FF6384',
        '#36A2EB',
        '#FFCE56',
        '#4BC0C0',
        '#9966FF',
        '#FF9F40'
      ],
      data: dataValues
    }]
  };
};

onMounted(fetchWorkingTimes);
</script>

<template>
  <div id="wt_main">

    <div id="chart_wrapper">
      <h2>Hours worked by user this week</h2>
      <div id="pie">
        <Pie v-if="chartData" :data="chartData" :options="chartOptions" />
      </div>
      <div id="datepicker_wrapper">
        <input class="dp" type="datetime-local" v-model="start" @change="fetchWorkingTimes" />
        <input class="dp" type="datetime-local" v-model="end" @change="fetchWorkingTimes" />
        <button class="dp" @click="fetchWorkingTimes">Get Working Times</button>
      </div>
    </div>
  </div>
</template>

<style scoped>
#wt_main {
  width: calc(100% - 20px);
  height: calc(100% - 20px);
  padding: 20px;
}
#wt_main h2 {
  text-align: center;
  margin-bottom: 20px;
}
#datepicker_wrapper {
  margin: 30px 0 20px 0;
}
#datepicker_wrapper{
  text-align: center;
}

.dp {
  margin-right: 10px;
}

#chart_wrapper {
  margin: auto;
}
</style>