<template>
  <div class="register">
    <!-- <img src="../assets/logo.png" alt="Logo" /> -->
    <h1>Time Manager</h1>
    <h2>Inscription</h2>
    <form @submit.prevent="handleRegister">
      <label for="username">Nom d'utilisateur</label>
      <input v-model="username" type="text" placeholder="Nom d'utilisateur" required />
      <label for="email">Email</label>
      <input v-model="email" type="email" placeholder="Email" required />
      <label for="password">Mot de passe</label>
      <input v-model="password" type="password" placeholder="Mot de passe" required />
      <button type="submit">S'inscrire</button>
    </form>
    <p v-if="error" class="error">{{ error }}</p>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue';
import { useRouter } from 'vue-router';
import { register } from '../../services/authService';

const router = useRouter();
const username = ref('');
const email = ref('');
const password = ref('');
const error = ref('');

const isValid = computed(() => {
  return username.value.length >= 3 && 
         email.value.includes('@') && 
         password.value.length >= 6;
});

const handleRegister = async () => {
  if (!isValid.value) {
    error.value = 'Veuillez remplir tous les champs correctement.';
    return;
  }
  
  try {
    await register(username.value, email.value, password.value);
    router.push('/');
  } catch (err) {
    error.value = err.response?.data?.error || 'Échec de l\'inscription.';
  }
};
</script>

<style scoped>
.register {
  display: flex;
  flex-direction: column;
  text-align: center;
}

.register img {
  height: 100px;
}

.register h1 {
  font-size: 24px;
}

.register h2 {
  font-size: 20px;
}

.register input {
  margin-bottom: 15px;
}
</style>