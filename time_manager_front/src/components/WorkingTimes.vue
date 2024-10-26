<script setup>
import WorkingTime from './WorkingTime.vue';
import { ref, onMounted, nextTick } from 'vue';
import { createWorkingTime, getWorkingTimesUserId } from '@/services/workingTimeService';
import { user } from '@/services/userService';


const userId = localStorage.getItem('userId');
const start = ref('2000-01-01T00:00:00');
const end = ref('2030-12-31T23:59:59');
const day_wts = ref([]);

const newStart = ref('');
const newEnd = ref('');

const fetchWorkingTimes = async () => {
  try {
    const data = await getWorkingTimesUserId(userId, start.value, end.value);
    day_wts.value = data;
  } catch (error) {
    console.error('Error in fetchWorkingTimes:', error);
  }
};

const handleCreateWorkingTime = async () => {
  try {
    const newWorkingTime = await createWorkingTime(userId, 
    {
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

<template>
  <div id="wt_main">

    <div id="create_wrapper" class="box">
      <h3>Create New Working Time</h3>
      <input class="dp" type="datetime-local" v-model="newStart" placeholder="Start time" />
      <input class="dp" type="datetime-local" v-model="newEnd" placeholder="End time" />
      <button class="dp" @click="handleCreateWorkingTime">Create</button>
    </div>

    <div id="datepicker_wrapper" class="box">
      <input class="dp" type="datetime-local" v-model="start" @change="fetchWorkingTimes" />
      <input class="dp" type="datetime-local" v-model="end" @change="fetchWorkingTimes" />
      <button class="dp" @click="fetchWorkingTimes">Get Working Times</button>
    </div>

    <div id="h_wrapper" class="box">
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

<style scoped>
/* Vos styles existants */

.box {
  box-shadow: 0 0 20px 0px rgba(0, 0, 0, 0.365);
  overflow: scroll;
  background-color: white;
  border: 20px solid white;
  border-radius: 10px;
  margin: 0 auto;
  text-align: center;
  width: 80%;
  max-width: 600px;
  max-height: 85%;
  margin-top: 2em;
  margin-bottom: 2em;
}


#h_wrapper {
  display: flex;
  flex-direction: column;
}

#create_wrapper h3 {
  margin-bottom: 0.5em;
}

#create_wrapper input, #create_wrapper button {
  margin: 0.5em;
}
</style>
