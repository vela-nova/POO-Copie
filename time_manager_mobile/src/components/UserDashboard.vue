<template>
  <div class="dashboard">
    <h1>Tableau de bord</h1>
    <div class="charts">
      <WorkingTimesChart :userId="userId" />
      <ClockManager />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import WorkingTimesChart from './WorkingTimesChart.vue';
import ClockManager from './ClockManager.vue';

const userId = ref(localStorage.getItem('userId'));

onMounted(() => {
  // Any additional setup can go here
});
</script>

<style scoped>
.dashboard {
  padding: 20px;
}

.charts {
  display: flex;
  flex-direction: column;
}
</style>