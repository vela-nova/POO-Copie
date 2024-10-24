
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
    console.log('Users loaded:', data);
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
      <div id="raw-1">
        <div id="raw-1-col-1">
          <WorkingTimesChart />
        </div>
        <div id="raw-1-col-2">
          <ClockManager />
        </div>
      </div>
      <div id="raw-2">
        <div id="raw-2-col-1">
          <HourWeekWork :userId="userId" :isAdmin="isAdmin" :users="users"/>
        </div>
        <div id="raw-2-col-2">
          <MonthWeekWork :userId="userId" :isAdmin="isAdmin" :users="users" />
        </div>
      </div>
    </template>
  </div>
</template>

<style scoped>
#raw-1 {
  display: flex;
  flex-direction: row;
  width: 100%-2px;
  height: 50%;
}

#raw-1-col-1 {
  display: flex;
  width: 40%;
  min-height: 80%;
  background-color: #D9D9D9;
  margin: auto;
  border-radius: 35px;
  box-shadow: 0 0 20px 0px rgba(0, 0, 0, 0.365);
}

#raw-1-col-2 {
  display: flex;
  width: 40%;
  min-height: 80%;
  background-color: #D9D9D9;
  border-radius: 35px;
  align-items: center;
  margin: 0 6% 0 0;
  box-shadow: 0 0 20px 0px rgba(0, 0, 0, 0.365);
}

#raw-2 {
  display: flex;
  flex-direction: row;  
  width: 100%-2px;
  height: 50%;
  margin: 50px 0 0 0;
}

#raw-2-col-1 {
  display: flex;
  width: 40%;
  min-height: 80%;
  background-color: #D9D9D9;
  margin: auto;
  border-radius: 35px;
  box-shadow: 0 0 20px 0px rgba(0, 0, 0, 0.365);
}

#raw-2-col-2 {
  display: flex;
  width: 40%;
  min-height: 80%;
  background-color: #D9D9D9;
  margin: auto;
  border-radius: 35px;
  margin: 0 6% 0 0;
  box-shadow: 0 0 20px 0px rgba(0, 0, 0, 0.365);
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