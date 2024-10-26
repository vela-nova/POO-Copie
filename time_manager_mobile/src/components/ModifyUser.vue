<template>
  <div class="modify-user">
    <h1>Modifier l'utilisateur</h1>
    <form @submit.prevent="handleUpdateUser">
      <div>
        <label for="username">Nom d'utilisateur:</label>
        <input type="text" id="username" v-model="updateUsername" required />
      </div>
      <div>
        <label for="email">Email:</label>
        <input type="email" id="email" v-model="updateEmail" required />
      </div>
      <button type="submit">Mettre à jour</button>
    </form>
    <button @click="handleDeleteUser" class="delete-button">Supprimer l'utilisateur</button>
    <p v-if="errorMessage" :class="{ 'error': errorMessage.includes('Failed'), 'success': !errorMessage.includes('Failed') }">
      {{ errorMessage }}
    </p>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { updateUser, deleteUser, user } from '../services/userService';

const updateEmail = ref('');
const updateUsername = ref('');
const errorMessage = ref('');

onMounted(() => {
  if (user.value) {
    updateEmail.value = user.value.email;
    updateUsername.value = user.value.username;
  }
});

const handleUpdateUser = async () => {
  errorMessage.value = '';
  try {
    await updateUser({ username: updateUsername.value, email: updateEmail.value });
    errorMessage.value = 'Utilisateur mis à jour avec succès';
  } catch (error) {
    errorMessage.value = `Échec de la mise à jour de l'utilisateur: ${error.message}`;
  }
};

const handleDeleteUser = async () => {
  errorMessage.value = '';
  if (confirm('Êtes-vous sûr de vouloir supprimer cet utilisateur ?')) {
    try {
      await deleteUser();
      errorMessage.value = 'Utilisateur supprimé avec succès';
      // Optionally redirect or perform another action after deletion
    } catch (error) {
      errorMessage.value = `Échec de la suppression de l'utilisateur: ${error.message}`;
    }
  }
};
</script>

<style scoped>
.modify-user {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.error {
  color: red;
}

.success {
  color: green;
}

.delete-button {
  margin-top: 20px;
}
</style>