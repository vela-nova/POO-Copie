<script setup>
import { ref, computed } from 'vue';
import { useRouter } from 'vue-router';
import { register } from '@/services/authService';

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
    error.value = 'Please fill all fields correctly.';
    return;
  }
  try {
    await register(username.value, email.value, password.value);
    router.push('/');
  } catch (err) {
    console.error('Registration error:', err.response?.data || err.message);
    error.value = err.response?.data?.error || 'Registration failed. Please try again.';
  }
};
</script>

<template>
  <div class="register">
    <img src="@/assets/logo.png" alt="Logo" />
    <h1>Gotham Time Manager</h1>
    <h2>Register</h2>
    <form @submit.prevent="handleRegister">
      <label for="username">Username</label>
      <input v-model="username" type="text" placeholder="Username" required>
      <label for="email">Email</label>
      <input v-model="email" type="email" placeholder="Email" required>
      <label for="password">Password</label>
      <input v-model="password" type="password" placeholder="Password" required>
      <button type="submit">Register</button>
    </form>
    <p v-if="error" class="error">{{ error }}</p>
  </div>
</template>

<style scoped>
.register {
  display: flex;
  flex-direction: column;
  text-align: center;
  margin: 2% 0 0 33%;
}

.register h1 {
  font-size: 60px;
  margin: 0 0 50px 0;
}

.register h2 {
  font-size: 40px;
  margin: 0;
}

.register img {
  height: 300px;
  width: 300px;
  margin: 0 0 0 40px;
}

.register form {
  display: flex;
  flex-direction: column;
  margin-bottom: 20px;
}
.register label {
  text-align: left;
  margin-bottom: 5px;
}
.register input {
  margin-bottom: 50px;
  padding: 10px;
  border-radius: 5px;
  border: 1px solid #ccc;
}

.register button {
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