<script setup>
import { ref, onMounted, watch } from 'vue';
import { creatClock, clockTime } from '@/services/clockService';

const userId = ref(localStorage.getItem('userId'));
const isActive = ref(localStorage.getItem('isActive') === 'true');
const clockStatus = ref(!isActive.value);


onMounted(() => {
  // Assurez-vous que l'état initial est correctement défini
  updateClockStatus();
});

watch(isActive, (newValue) => {
  localStorage.setItem('isActive', newValue);
  updateClockStatus();
});

function updateClockStatus() {
  clockStatus.value = !isActive.value;
}

const clock = async () => {
  try {
    clockTime.value = new Date().toLocaleString();
    await creatClock(!isActive.value);
    isActive.value = !isActive.value;
    // Pas besoin de mettre à jour localStorage ici, le watcher s'en chargera
    
    if (!isActive.value) {
      refresh();
    }
  } catch (error) {
    console.error('Error in clock function:', error);
  }
};

const refresh = () => {
  clockTime.value = null;
  isActive.value = false;
};

</script>

<template>
  <div id="clockManager">
    <h1 v-if="userId">Status of employee : {{ userId }}</h1>
    <button id="active-button" @click="clock" :class="{ 'active': isActive }">
      <span class="button-text">{{ isActive ? 'Active' : 'Inactive' }}</span>
    </button>
  </div>
</template>

<style scoped>
#clockManager {
  width: 100%;
  height: 100%;
  margin: auto;
  border-radius: 4px;
  display: flex;
  flex-direction: column;
  text-align: center;
  align-items: center;
}
#clockManager>h1 {
  margin-bottom: 0;
}

#active-button {
  width: 150px;
  height: 150px;
  border-radius: 50%;
  font-size: 18px;
  font-weight: 800;
  cursor: pointer;
  transition: all 0.3s ease;
  background-color: transparent;
  border: 8px solid #ef1919;
  position: relative;
  overflow: hidden;
  margin: auto;
}

@media (max-width: 1000px) {
  #active-button {
    margin: 2em;
  }
}

#active-button::before {
  content: '';
  position: absolute;
  top: -2px;
  left: -2px;
  right: -2px;
  bottom: -2px;
  background-color: #e52727;
  border-radius: 50%;
  z-index: -1;
  transition: all 0.3s ease;
}

#active-button.active {
  border-color: #4CAF50;
}

#active-button.active::before {
  background-color: #4CAF50;
}

.button-text {
  position: relative;
  z-index: 1;
  transition: color 0.3s ease;
}

</style>