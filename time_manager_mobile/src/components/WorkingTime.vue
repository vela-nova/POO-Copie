
<template>
    <div id="wt_main">
        <div class="wt_seg" v-if="!isEditing && formattedStartDate">
            <p>{{ formattedStartDate.year }}</p>
            <p>{{ formattedStartDate.month }} {{ formattedStartDate.date }}</p>
            <p>{{ formattedStartDate.time }}</p>
        </div>
        <div class="wt_seg" v-else>
            <input type="datetime-local" :value="startDate.toString()" @input="updateStartDate" />
        </div>
        <p>→</p>
        <div class="wt_seg" v-if="!isEditing && formattedEndDate">
            <p>{{ formattedEndDate.year }}</p>
            <p>{{ formattedEndDate.month }} {{ formattedEndDate.date }}</p>
            <p>{{ formattedEndDate.time }}</p>
        </div>
        <div class="wt_seg" v-else>
            <input type="datetime-local" :value="endDate.toString()" @input="updateEndDate" />
        </div>
        <div class="wt_seg">
            <span>User ID: {{ props.userId }}</span>
            <button class="dp" v-if="!isEditing" @click="isEditing = true">Edit</button>
            <button class="dp" v-else @click="handleUpdate">Save</button>
            <button class="dp" @click="handleDelete">Delete</button>
        </div>
    </div>
</template>

<script setup>
import { defineProps, ref, computed } from 'vue';
import { deleteWorkingTime, updateWorkingTime } from '../services/workingTimeService';

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
function formatDate(date) {
  return date.toISOString().split('T')[0] + 'T00:00:00';
}

const today = new Date();

const startOfWeek = new Date(today);
startOfWeek.setDate(today.getDate() - today.getDay() + (today.getDay() === 0 ? -6 : 1));

const endOfWeek = new Date(startOfWeek);
endOfWeek.setDate(startOfWeek.getDate() + 6);
endOfWeek.setHours(23, 59, 59);


const startDate = ref(formatDate(startOfWeek));
const endDate = ref(endOfWeek.toISOString().replace('Z', ''));

const isEditing = ref(false);

const isValidDate = (date) => date instanceof Date && !isNaN(date);

const formattedStartDate = computed(() => {
  if (isValidDate(startDate.value)) {
    return {
      year: startDate.value.getFullYear(),
      month: startDate.value.toLocaleString('default', { month: 'long' }),
      date: startDate.value.getDate(),
      time: startDate.value.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
    };
  }
  return null;
});

const formattedEndDate = computed(() => {
  if (isValidDate(endDate.value)) {
    return {
      year: endDate.value.getFullYear(),
      month: endDate.value.toLocaleString('default', { month: 'long' }),
      date: endDate.value.getDate(),
      time: endDate.value.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
    };
  }
  return null;
});

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
    const updatedWorkingTime = await updateWorkingTime(props.wtId, {
      start: startDate.value instanceof Date ? startDate.value.toISOString() : startDate.value,
      end: endDate.value instanceof Date ? endDate.value.toISOString() : endDate.value
    });
    emit('workingTimeUpdated', { ...updatedWorkingTime, id: props.wtId });
    isEditing.value = false;
  } catch (error) {
    console.error('Error updating working time:', error);
  }
};

const updateStartDate = (event) => {
  startDate.value = new Date(event.target.value);
};

const updateEndDate = (event) => {
  endDate.value = new Date(event.target.value);
};
</script>

<style scoped>
/* Vos styles existants */

input[type="datetime-local"] {
    padding: 0.5em;
    border: 1px solid #9bbdd7;
    border-radius: 4px;
}
</style>