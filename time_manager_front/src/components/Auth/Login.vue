<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { login } from '@/services/authService';

const router = useRouter();
const email = ref('');
const password = ref('');
const error = ref('');

const handleLogin = async () => {
  try {
    await login(email.value, password.value);
    router.push('/');
  } catch (err) {
    error.value = 'Invalid email or password';
  }
};
</script>

<template>
  <div class="login">
    <img src="@/assets/logo.png" alt="Logo" />
    <h1>Gotham Time Manager</h1>
    <h2>Login</h2>
    <form @submit.prevent="handleLogin">
      <label for="email">Email</label>
      <input v-model="email" type="email" placeholder="Email" required>
      <label for="password">Password</label>
      <input v-model="password" type="password" placeholder="Password" required>
      <button type="submit">Login</button>
    </form>
      <router-link to="/register">Register</router-link> 
    <p v-if="error" class="error">{{ error }}</p>
  </div>
</template>

<style scoped>
.login {
  display: flex;
  flex-direction: column;
  text-align: center;
  margin: auto;
}

.login h1 {
  font-size: 60px;
  margin: 0 0 50px 0;
}

.login h2 {
  font-size: 40px;
  margin: 0;
}

.login img {
  height: 300px;
  width: 300px;
  margin: auto;
}

.login form {
  display: flex;
  flex-direction: column;
  margin-bottom: 20px;
}
.login label {
  text-align: left;
  margin-bottom: 5px;
}
.login input {
  margin-bottom: 50px;
  padding: 10px;
  border-radius: 5px;
  border: 1px solid #ccc;
}

.login button {
  padding: 10px;
  width: 50%;
  border-radius: 70px;
  background-color: #007bff;
  color: white;
  border: none;
  cursor: pointer;
  margin: auto;
}
</style>