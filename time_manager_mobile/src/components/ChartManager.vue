

<template>
  <div class="chart-container">
    <h2>Statistiques</h2>
    <select v-model="userId" @change="fetchAllData">
      <option :value="null">Sélectionnez un utilisateur</option>
      <option value="1">Utilisateur 1</option>
      <option value="2">Utilisateur 2</option>
      <!-- Ajoutez d'autres options selon vos besoins -->
    </select>
    <div v-if="userCountData" class="chart">
      <h3>Nombre d'utilisateurs</h3>
      <Bar :data="userCountData" />
    </div>
    <div v-if="userPresenceData && userPresenceData.datasets[0].data.length > 0" class="chart">
      <h3>Présence de l'utilisateur</h3>
      <Line :data="userPresenceData" />
    </div>
    <div v-else-if="userId">
      <p>Pas de données de présence disponibles pour cet utilisateur</p>
    </div>
    <div v-if="workingTimeData && workingTimeData.datasets[0].data.length > 0 && workingTimeData.datasets[0].data.some(v => v > 0)" class="chart">
      <h3>Temps de travail</h3>
      <Bar :data="workingTimeData" :options="workingTimeOptions" />
    </div>
    <div v-else-if="userId">
      <p>Pas de données de temps de travail valides disponibles pour cet utilisateur</p>
    </div>
    <div v-if="!userId">
      <p>Veuillez sélectionner un utilisateur pour voir les données spécifiques</p>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue';
import { Bar, Line } from 'vue-chartjs';
import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale, PointElement, LineElement } from 'chart.js';
import { userId as userIdRef, setUserId } from '../services/userService';
import { getUsers } from '../services/userService';
import { getClocks } from '../services/clockService';
import { getWorkingTimesUserId } from '../services/workingTimeService';

ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale, PointElement, LineElement);

const userCountData = ref(null);
const userPresenceData = ref(null);
const workingTimeData = ref(null);
const userId = ref(null);

const workingTimeOptions = {
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

const fetchUserCount = async () => {
  try {
    console.log('Fetching user count');
    const users = await getUsers();
    console.log('User count response:', users);
    userCountData.value = {
      labels: ['Utilisateurs'],
      datasets: [{
        label: 'Nombre d\'utilisateurs',
        data: [users.length],
        backgroundColor: ['rgba(75, 192, 192, 0.6)']
      }]
    };
  } catch (error) {
    console.error('Error fetching user count:', error);
  }
};

const fetchUserPresence = async () => {
  if (userId.value) {
    try {
      console.log(`Fetching user presence for userId: ${userId.value}`);
      const clocks = await getClocks(userId.value);
      console.log('User presence response:', clocks);
      userPresenceData.value = {
        labels: clocks.map(clock => new Date(clock.time).toLocaleDateString()),
        datasets: [{
          label: 'Temps de présence',
          data: clocks.map(clock => clock.status ? 1 : 0),
          borderColor: 'rgb(75, 192, 192)',
          tension: 0.1
        }]
      };
    } catch (error) {
      console.error('Error fetching user presence:', error);
    }
  }
};

const fetchWorkingTime = async () => {
  if (userId.value) {
    try {
      console.log(`Fetching working time for userId: ${userId.value}`);
      const workingTimes = await getWorkingTimesUserId(userId.value);
      console.log('Working time response:', workingTimes);
      
      const calculatedData = workingTimes.map(wt => {
        const start = new Date(wt.start);
        const end = new Date(wt.end);
        return (end - start) / (1000 * 60 * 60);
      });
      console.log('Calculated working hours:', calculatedData);

      workingTimeData.value = {
        labels: workingTimes.map(wt => {
          const date = new Date(wt.start);
          return date instanceof Date && !isNaN(date) ? date.toLocaleDateString() : 'Date invalide';
        }),
        datasets: [{
          label: 'Heures travaillées',
          data: workingTimes.map(wt => {
            const start = new Date(wt.start);
            const end = new Date(wt.end);
            if (start instanceof Date && !isNaN(start) && end instanceof Date && !isNaN(end)) {
              return Math.max(0, (end - start) / (1000 * 60 * 60)); // Assure une valeur positive
            }
            return 0; // Retourne 0 si les dates sont invalides
          }),
          backgroundColor: ['rgba(255, 99, 132, 0.6)']
        }]
      };
    } catch (error) {
      console.error('Error fetching working time:', error);
    }
  }
};

const fetchAllData = async () => {
  await fetchUserCount();
  if (userId.value) {
    await fetchUserPresence();
    await fetchWorkingTime();
  } else {
    console.log('No userId available, skipping user-specific data fetch');
    userPresenceData.value = null;
    workingTimeData.value = null;
  }
};

onMounted(() => {
  console.log('ChartManager mounted, userId:', userId.value);
  fetchAllData();
});

watch(userId, (newUserId) => {
  console.log('userId changed:', newUserId);
  userIdRef.value = newUserId;
  fetchAllData();
});
</script>
<style scoped>
.chart-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 100%;
  max-width: 800px;
  margin: 0 auto;
}

.chart {
  width: 100%;
  margin-bottom: 2rem;
}

h2 {
  text-align: center;
  margin-bottom: 1rem;
}

h3 {
  text-align: center;
  margin-bottom: 0.5rem;
}

select {
  margin-bottom: 1rem;
  padding: 0.5rem;
  font-size: 1rem;
}
</style>