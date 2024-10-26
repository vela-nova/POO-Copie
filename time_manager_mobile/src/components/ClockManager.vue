<template>
  <div class="clock-manager">
    <h2>Gestionnaire d'Horloge</h2>
    <button @click="toggleClock" :class="{ active: isActive }">
      {{ isActive ? 'Désactiver' : 'Activer' }} l'horloge
    </button>
    <p v-if="isActive">Statut: Actif</p>
    <p v-else>Statut: Inactif</p>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { clockStatus, createClock } from '../services/clockService';

const isActive = ref(false);

const toggleClock = async () => {
  try {
    await createClock(); // Call the service to create a clock entry
    isActive.value = !isActive.value; // Toggle the active state
    clockStatus.value = isActive.value; // Update the clock status
  } catch (error) {
    console.error('Erreur lors de la gestion de l\'horloge:', error);
  }
};
</script>

<style scoped>
.clock-manager {
  display: flex;
  flex-direction: column;
  align-items: center;
}

button {
  padding: 10px;
  margin-top: 20px;
}
</style>