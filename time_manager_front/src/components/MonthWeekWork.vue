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
        default: 22 // Par exemple, le travail de nuit commence à 22h
        },
        nightWorkEndHour: {
            type: Number,
            default: 6 // Par exemple, le travail de nuit se termine à 6h
        },
        maxRegularHours: {
            type: Number,
            default: 35 // Par exemple, 35 heures par semaine
        }
    });

    const { users } = props;

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
    const selectedUserId = ref(props.userId);

    const updateUserId = (event) => {
        const newUserId = event.target.value;
        selectedUserId.value = newUserId;
        localStorage.setItem('userId', newUserId);
    };
    const chartData = computed(() => {
    const monthlyHours = {};
    const allMonths = [];

   

    let currentDate = new Date(startOfPeriod);
    while (currentDate <= endOfMonth) {
        const monthKey = getMonthKey(currentDate);
        allMonths.push(monthKey);
        monthlyHours[monthKey] = 0;
        currentDate.setMonth(currentDate.getMonth() + 1);
    }

    workingTimes.value.forEach(wt => {
        const { regularHours, nightHours, overtimeHours } = calculateHours(
            wt.start,
            wt.end,
            props.nightWorkStartHour,
            props.nightWorkEndHour,
            props.maxRegularHours
        );
        const monthKey = getMonthKey(new Date(wt.start));

        if (!monthlyHours[monthKey]) {
            monthlyHours[monthKey] = { regular: 0, night: 0, overtime: 0 };
        }
        monthlyHours[monthKey].regular += regularHours;
        monthlyHours[monthKey].night += nightHours;
        monthlyHours[monthKey].overtime += overtimeHours;
    });

    const labels = allMonths;
    const regularData = labels.map(month => monthlyHours[month]?.regular || 0);
    const nightData = labels.map(month => monthlyHours[month]?.night || 0);
    const overtimeData = labels.map(month => monthlyHours[month]?.overtime || 0);

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

    function calculateHours(start, end, nightStartHour, nightEndHour, maxRegularHours) {
        const startDate = new Date(start);
        const endDate = new Date(end);
        let regularHours = 0;
        let nightHours = 0;
        let overtimeHours = 0;

        let currentHour = startDate.getHours();
        let hoursWorked = (endDate - startDate) / (1000 * 60 * 60);

        while (hoursWorked > 0) {
            if (currentHour >= nightStartHour || currentHour < nightEndHour) {
                nightHours++;
            } else {
                if (regularHours < maxRegularHours) {
                    regularHours++;
                } else {
                    overtimeHours++;
                }
            }
            hoursWorked--;
            currentHour = (currentHour + 1) % 24;
        }

        return { regularHours, nightHours, overtimeHours };
    }

    function getMonthKey(date) {
    return `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}`;
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
        props.userId = newValue;
        try {
            const data = await getWorkingTimesUserId(selectedUserId.value, start.value, end.value);
            workingTimes.value = data;
        } catch (error) {
            console.error('Erreur lors de la récupération des temps de travail:', error);
        }
    });
    console.log("qsdqdqsdqsdqsd",selectedUserId)
</script>

<template>
  <div class="chart-container">
    <h2>Heures travaillées par mois</h2>
    <div v-if="props.isAdmin"  class="select-container">
      <label for="numberSelect">Sélectionnez un numéro :</label>
      <select id="numberSelect" v-model="selectedUserId" @change="updateUserId">
        <option v-for="user in users" :key="user.id" :value="user.id">
          {{ user.id }}
        </option>
      </select>
    </div>
    <Bar v-if="workingTimes.length > 0" :data="chartData" :options="chartOptions" />
    <p v-else>Aucune donnée disponible</p>
  </div>
</template>

<style scoped>
    .chart-container {
    width: 95%;
    margin: 0 auto;
    text-align: center;
    }
</style>