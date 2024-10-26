

<template>
  <div class="chart-container">
    <h2>Heures travaillées par mois</h2>
    <div class="select-container">
      <label for="numberSelect">Sélectionnez un numéro :</label>
      <select id="numberSelect" v-model="props.userId.userId">
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
    import { getWorkingTimesUserId } from '../services/workingTimeService';

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
    const userId = ref(localStorage.getItem('userId'));
    const workingTimes = ref([]);

    function formatDate(date) {
    return date.toISOString().split('T')[0] + 'T00:00:00';
    }

    const today = new Date();
    const endOfMonth = new Date(today.getFullYear(), today.getMonth() + 1, 0, 23, 59, 59);
    const startOfPeriod = new Date(endOfMonth);
    startOfPeriod.setMonth(startOfPeriod.getMonth() - 11); // 12 mois en arrière
    startOfPeriod.setDate(1); // Premier jour du mois
    startOfPeriod.setHours(0, 0, 0, 0);

    const start = ref(formatDate(startOfPeriod));
    const end = ref(endOfMonth.toISOString().replace('Z', ''));

    const chartData = computed(() => {
    const monthlyHours = {};
    const allMonths = [];

    // Générer tous les mois de la période
    let currentDate = new Date(startOfPeriod);
    while (currentDate <= endOfMonth) {
        const monthKey = getMonthKey(currentDate);
        allMonths.push(monthKey);
        monthlyHours[monthKey] = 0;
        currentDate.setMonth(currentDate.getMonth() + 1);
    }

    workingTimes.value.forEach(wt => {
        const startDate = new Date(wt.start);
        const endDate = new Date(wt.end);
        const monthKey = getMonthKey(startDate);
        const hoursWorked = (endDate - startDate) / (1000 * 60 * 60);

        monthlyHours[monthKey] += hoursWorked;
    });

    const labels = allMonths;
    const data = labels.map(month => monthlyHours[month]);

    return {
        labels,
        datasets: [
        {
            label: 'Heures travaillées par mois',
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
            text: 'Mois'
        },
        ticks: {
            maxRotation: 45,
            minRotation: 45
        }
        }
    },
    plugins: {
        tooltip: {
        callbacks: {
            title: (tooltipItems) => {
            const monthLabel = tooltipItems[0].label;
            const [year, month] = monthLabel.split('-');
            const date = new Date(year, parseInt(month) - 1);
            return date.toLocaleString('fr-FR', { month: 'long', year: 'numeric' });
            }
        }
        }
    }
    };

    function getMonthKey(date) {
    return `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}`;
    }

    onMounted(async () => {
    if (props.userId.userId) {
        try {
        const data = await getWorkingTimesUserId(props.userId.userId, start.value, end.value);
        workingTimes.value = data;
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