
<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import ClockManager from './ClockManager.vue';
import WorkingTimesChart from './WorkingTimesChart.vue';
import HourWeekWork from './HourWeekWork.vue';
import MonthWeekWork from './MonthWeekWork.vue';
import { currentUser } from '@/services/authService';
import { getUsers } from '@/services/userService';

const userId = ref(localStorage.getItem('userId'));
const isAdmin = computed(() => currentUser.value?.role === 'admin');
const users = ref([]);
const isLoading = ref(true);

onMounted(async () => {
  try {
    const data = await getUsers();
    users.value = data;
  } catch (error) {
    console.error('Error fetching users:', error);
  } finally {
    isLoading.value = false;
  }
});

</script>

<template>
  <div class="dashboard">
    <div v-if="isLoading" class="loading">
      Chargement en cours...
    </div>
    <template v-else>
      <div class="row">
        <div class="col">
          <WorkingTimesChart />
        </div>
        <div class="col">
          <ClockManager />
        </div>
      </div>
      <div class="row">
        <div class="col">
          <HourWeekWork :userId="userId" :isAdmin="isAdmin" :users="users"/>
        </div>
        <div class="col">
          <MonthWeekWork :userId="userId" :isAdmin="isAdmin" :users="users" />
        </div>
      </div>
    </template>
  </div>
</template>

<style scoped>
.row {
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items: center;
  width: calc(100% - 2px);
  height: 50%;
  margin-top: 3em;
}

.col {
  display: flex;
  width: 40%;
  background-color: white;
  margin: auto;
  border-radius: 35px;
  box-shadow: 0 0 20px 0px rgba(0, 0, 0, 0.365);
}

.row:first-of-type>.col{
  height: 35em;
}

@media (max-width: 1000px) {
  .row {
    flex-direction: column;
    margin-top: auto;
  }
  .col{
    width: 80%;
    margin-top: 3em;
    height: fit-content !important;
  }
}
.loading {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  font-size: 1.5em;
  color: #666;
}
</style>