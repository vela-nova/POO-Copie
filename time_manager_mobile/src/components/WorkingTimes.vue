
<template>
  <div id="wt_main">
    <div id="datepicker_wrapper">
      <input class="dp" type="datetime-local" v-model="start" @change="fetchWorkingTimes" />
      <input class="dp" type="datetime-local" v-model="end" @change="fetchWorkingTimes" />
      <button class="dp" @click="fetchWorkingTimes">Get Working Times</button>
    </div>

    <div id="create_wrapper">
      <h3>Create New Working Time</h3>
      <input class="dp" type="datetime-local" v-model="newStart" placeholder="Start time" />
      <input class="dp" type="datetime-local" v-model="newEnd" placeholder="End time" />
      <button class="dp" @click="handleCreateWorkingTime">Create</button>
    </div>

    <div id="h_wrapper">
      <div class="wt_wrapper" v-for="wt in day_wts" :key="wt.id">
        <WorkingTime 
          :wtId="wt.id"
          :start="wt.start" 
          :end="wt.end" 
          :userId="wt.user_id"
          @working-time-deleted="handleWorkingTimeDeleted"
          @working-time-updated="handleWorkingTimeUpdated">
        </WorkingTime>
      </div>
    </div>
  </div>
</template>


<script setup>
import WorkingTime from './WorkingTime.vue';
import { ref, onMounted, nextTick } from 'vue';
import { getWorkingTimes, createWorkingTime } from '../services/workingTimeService';

const userId = ref(1);
const start = ref('2000-01-01T00:00:00');
const end = ref('2030-12-31T23:59:59');
const day_wts = ref([]);

const newStart = ref('');
const newEnd = ref('');

const fetchWorkingTimes = async () => {
  try {
    console.log('Fetching working times...');
    const data = await getWorkingTimes(userId.value, start.value, end.value);
    console.log('Received working times:', data);
    day_wts.value = data;
  } catch (error) {
    console.error('Error in fetchWorkingTimes:', error);
  }
};

const handleCreateWorkingTime = async () => {
  try {
    const newWorkingTime = await createWorkingTime(userId.value, {
      start: newStart.value,
      end: newEnd.value
    });
    day_wts.value.push(newWorkingTime);
    newStart.value = '';
    newEnd.value = '';
  } catch (error) {
    console.error('Error creating new working time:', error);
  }
};

const handleWorkingTimeDeleted = (deletedId) => {
  day_wts.value = day_wts.value.filter(wt => wt.id !== deletedId);
};

const handleWorkingTimeUpdated = async (updatedWorkingTime) => {
  const index = day_wts.value.findIndex(wt => wt.id === updatedWorkingTime.id);
  if (index !== -1) {
    day_wts.value[index] = updatedWorkingTime;
    await nextTick();
  }
};

onMounted(fetchWorkingTimes);
</script>

<style scoped>
/* Vos styles existants */

#create_wrapper {
  background-color: #f0f8ff;
  padding: 1em;
  margin-bottom: 1em;
  border-radius: 8px;
}

#create_wrapper h3 {
  margin-bottom: 0.5em;
}

#create_wrapper input, #create_wrapper button {
  margin: 0.5em;
}
</style>
