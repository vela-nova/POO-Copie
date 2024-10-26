<template>
  <div class="working-times-chart">
    <h2>Heures Travaillées</h2>
    <Bar v-if="chartData" :data="chartData" :options="chartOptions" />
    <p v-else>Aucune donnée disponible.</p>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { Bar } from 'vue-chartjs';
import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale } from 'chart.js';
import { getWorkingTimesUserId } from '../services/workingTimeService';

ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale);

const userId = ref(localStorage.getItem('userId'));
const chartData = ref(null);
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
        text: 'Date'
      }
    }
  }
};

const fetchWorkingTimes = async () => {
  if (userId.value) {
    try {
      const workingTimes = await getWorkingTimesUserId(userId.value);
      const labels = workingTimes.map(wt => new Date(wt.start).toLocaleDateString());
      const data = workingTimes.map(wt => (new Date(wt.end) - new Date(wt.start)) / (1000 * 60 * 60));
      
      chartData.value = {
        labels,
        datasets: [{
          label: 'Heures travaillées',
          data,
          backgroundColor: 'rgba(75, 192, 192, 0.6)',
        }]
      };
    } catch (error) {
      console.error('Erreur lors de la récupération des heures travaillées:', error);
    }
  }
};

onMounted(fetchWorkingTimes);
</script>

<style scoped>
.working-times-chart {
  width: 100%;
}
</style>