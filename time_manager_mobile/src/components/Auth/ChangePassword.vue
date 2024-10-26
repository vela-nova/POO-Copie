<template>
  <div class="change-password">
    <h2>Changer le mot de passe</h2>
    <form @submit.prevent="handleChangePassword">
      <input v-model="currentPassword" type="password" placeholder="Mot de passe actuel" required />
      <input v-model="newPassword" type="password" placeholder="Nouveau mot de passe" required />
      <input v-model="confirmPassword" type="password" placeholder="Confirmer le nouveau mot de passe" required />
      <button type="submit">Changer le mot de passe</button>
    </form>
    <p v-if="error">{{ error }}</p>
    <p v-if="success">{{ success }}</p>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { changePassword } from '../../services/authService';

const currentPassword = ref('');
const newPassword = ref('');
const confirmPassword = ref('');
const error = ref('');
const success = ref('');

const handleChangePassword = async () => {
  if (newPassword.value !== confirmPassword.value) {
    error.value = 'Les nouveaux mots de passe ne correspondent pas.';
    return;
  }
  
  try {
    await changePassword(currentPassword.value, newPassword.value);
    success.value = 'Mot de passe changé avec succès.';
    
    currentPassword.value = '';
    newPassword.value = '';
    confirmPassword.value = '';
    
    setTimeout(() => {
      // Redirect or perform another action after success.
    }, 2000);
    
  } catch (err) {
    error.value = err.response?.data?.error || 'Échec du changement de mot de passe.';
  }
};
</script>

<style scoped>
.change-password {
   display: flex;
   flex-direction: column;
}
</style>