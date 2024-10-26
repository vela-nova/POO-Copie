<script setup>
import { defineProps, ref, computed } from 'vue';
import { deleteWorkingTime, updateWorkingTime } from '@/services/workingTimeService';

const props = defineProps({
    userId: {
        type: Number,
        required: true
    },
    wtId: {
        type: Number,
        required: true
    },
    start: {
        type: String,
        required: true
    },
    end: {
        type: String,
        required: true
    },
});

const emit = defineEmits(['workingTimeDeleted', 'workingTimeUpdated']);

let startDate = ref(new Date(props.start));
let endDate = ref(new Date(props.end));

const isEditing = ref(false);

let tempStartDate = new Date(props.start);
let tempEndDate = new Date(props.end);

const handleDelete = async () => {
    try {
        await deleteWorkingTime(props.wtId);
        emit('workingTimeDeleted', props.wtId);
    } catch (error) {
        console.error('Error deleting working time:', error);
    }
};

const handleUpdate = async () => {
  try {
    console.log(tempStartDate, tempEndDate)
    const updatedWorkingTime = await updateWorkingTime(props.wtId, {
      start: tempStartDate,
      end: tempEndDate
    });
    emit('workingTimeUpdated', { ...updatedWorkingTime, id: props.wtId });
    isEditing.value = false;
    startDate.value = tempStartDate;
    endDate.value = tempEndDate;

  } catch (error) {
    console.error('Error updating working time:', error);
  }
};

const updateStartDate = (event) => {
  tempStartDate = new Date(event.target.value);
};

const updateEndDate = (event) => {
  tempEndDate = new Date(event.target.value);
};

const cancelUpdate = () => {
  isEditing.value = false;
  tempStartDate = startDate.value;
  tempEndDate = endDate.value;
};

</script>

<template>
    <div id="wt_main">
        <div class="wt_seg" v-if="!isEditing">            
          <p>{{startDate.getFullYear()}}</p>
          <p>{{startDate.toLocaleString('default', { month: 'long' })}} {{startDate.getDate()}}</p>
          <p>{{startDate.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}}</p>
        </div>
        <div class="wt_seg" v-else>
          <input type="datetime-local" :value="tempStartDate.toISOString().substring(0, 16)" @input="updateStartDate" />
        </div>
        <p>→</p>
        <div class="wt_seg" v-if="!isEditing">            
          <p>{{endDate.getFullYear()}}</p>
          <p>{{endDate.toLocaleString('default', { month: 'long' })}} {{startDate.getDate()}}</p>
          <p>{{endDate.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}}</p>
        </div>
        <div class="wt_seg" v-else>
            <input type="datetime-local" :value="tempEndDate.toISOString().substring(0, 16)" @input="updateEndDate" />
        </div>
        <div class="wt_seg">
            <span>User ID: {{ props.userId }}</span>
            <button class="dp" v-if="!isEditing" @click="isEditing = true">Edit</button>
            <button class="dp" v-else @click="handleUpdate">Save</button>
            <button class="dp" v-if="!isEditing" @click="handleDelete">Delete</button>
            <button class="dp" v-else @click="cancelUpdate">Cancel</button>
        </div>
    </div>
</template>

<style scoped>
/* Vos styles existants */
#wt_main {
    display: flex; 
    flex-direction: row; 
    align-items: center; 
    justify-content: center;
    padding: 1em;
}
p {
    margin: 0;
}
.wt_seg{
    margin: none;  

    padding: 0.5em;
    margin:0.5em;
}
.dp{
    -webkit-appearance: none;
    border: none;
    border-bottom: 2px solid grey ;
    padding:0.5em;
    background-color: #dbe9f4;
    margin: 1em;
    margin-top: 0;
}
.dp:hover{
    background-color: #9bbdd7;
    border-bottom: 2px solid grey ;
}
</style>