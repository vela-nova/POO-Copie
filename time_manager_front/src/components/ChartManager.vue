<script setup>
import { ref, onMounted } from 'vue';
import { Bar, Line, Pie } from 'vue-chartjs';
import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale, PointElement, LineElement, ArcElement } from 'chart.js';
import axios from 'axios';
import { userId } from './utils';

ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale, PointElement, LineElement, ArcElement);

const userCountData = ref(null);
const userPresenceData = ref(null);
const workingTimeData = ref(null);

const fetchUserCount = async () => {
  const response = await axios.get('http://localhost:4000/api/users');
  const users = response.data.data;
  userCountData.value = {
    labels: ['Utilisateurs'],
    datasets: [{
      label: 'Nombre d\'utilisateurs',
      data: [users.length],
      backgroundColor: ['rgba(75, 192, 192, 0.6)']
    }]
  };
};

const fetchUserPresence = async () => {
  if (userId.value) {
    const response = await axios.get(`http://localhost:4000/api/clocks/${userId.value}`);
    const clocks = response.data.data;
    // Supposons que chaque clock a un champ 'time' et 'status'
    userPresenceData.value = {
      labels: clocks.map(clock => new Date(clock.time).toLocaleDateString()),
      datasets: [{
        label: 'Temps de présence',
        data: clocks.map(clock => clock.status ? 1 : 0),
        borderColor: 'rgb(75, 192, 192)',
        tension: 0.1
      }]
    };
  }
};

const fetchWorkingTime = async () => {
  if (userId.value) {
    const response = await axios.get(`http://localhost:4000/api/workingtimes/${userId.value}`);
    const workingTimes = response.data.data;
    // Supposons que chaque workingTime a des champs 'start' et 'end'
    workingTimeData.value = {
      labels: workingTimes.map(wt => new Date(wt.start).toLocaleDateString()),
      datasets: [{
        label: 'Heures travaillées',
        data: workingTimes.map(wt => {
          const start = new Date(wt.start);
          const end = new Date(wt.end);
          return (end - start) / (1000 * 60 * 60); // Convertit en heures
        }),
        backgroundColor: ['rgba(255, 99, 132, 0.6)']
      }]
    };
  }
};

onMounted(async () => {
  await fetchUserCount();
  if (userId.value) {
    await fetchUserPresence();
    await fetchWorkingTime();
  }
});
</script>

<template>
  <div>
    <Bar v-if="userCountData" :data="userCountData" />
    <Line v-if="userPresenceData" :data="userPresenceData" />
    <Bar v-if="workingTimeData" :data="workingTimeData" />
  </div>
</template>

<style scoped>
div {
  display: flex;
  flex-direction: column;
  align-items: center;
}
</style>