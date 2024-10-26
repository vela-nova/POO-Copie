<template>
  <div class="profile">
    <h2>Profil Utilisateur</h2>
    <div v-if="user">
      <p><strong>Nom d'utilisateur:</strong> {{ user.username }}</p>
      <p><strong>Email:</strong> {{ user.email }}</p>
      <p><strong>Rôle:</strong> {{ user.role }}</p>
    </div>
    <div v-else>
      <p>Chargement du profil...</p>
    </div>
    <router-link to="/change-password" class="change-password-btn">Changer le mot de passe</router-link>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { currentUser, checkAuth } from '../services/authService';

const user = ref(null);

const fetchUserProfile = async () => {
  try {
    await checkAuth();
    user.value = currentUser.value;
  } catch (error) {
    console.error('Erreur lors de la récupération du profil utilisateur:', error);
  }
};

onMounted(fetchUserProfile);
</script>

<style scoped>
.profile {
  max-width: 600px;
  margin: 0 auto;
  padding: 20px;
}

h2 {
  color: #333;
  margin-bottom: 20px;
}

p {
  margin-bottom: 10px;
}

.change-password-btn {
  display: inline-block;
  margin-top: 20px;
  padding: 10px 15px;
  background-color: #007bff;
  color: white;
  text-decoration: none;
  border-radius: 5px;
}

.change-password-btn:hover {
  background-color: #0056b3;
}
</style>