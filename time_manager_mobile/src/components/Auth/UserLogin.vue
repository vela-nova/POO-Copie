<template>
  <div class="login">
    <!-- <img src="../assets/logo.png" alt="Logo" /> -->
    <h1>Time Manager</h1>
    <h2>Connexion</h2>
    <form @submit.prevent="handleLogin">
      <label for="email">Email</label>
      <input v-model="email" type="email" placeholder="Email" required />
      <label for="password">Mot de passe</label>
      <input v-model="password" type="password" placeholder="Mot de passe" required />
      <button type="submit">Se connecter</button>
    </form>
    <p v-if="error" class="error">{{ error }}</p>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { login } from '../../services/authService';

const router = useRouter();
const email = ref('');
const password = ref('');
const error = ref('');

const handleLogin = async () => {
  try {
    await login(email.value, password.value);
    router.push('/');
  } catch (err) {
    error.value = 'Email ou mot de passe invalide';
  }
};
</script>

<style scoped>
.login {
  display: flex;
  flex-direction: column;
  text-align: center;
  margin: 2% auto;
}

.login img {
  height: 100px;
}

.login h1 {
  font-size: 24px;
}

.login h2 {
  font-size: 20px;
}

.login input {
  margin-bottom: 15px;
  padding: 10px;
}

.login button {
  padding: 10px;
}
</style>