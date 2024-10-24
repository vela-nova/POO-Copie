<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { changePassword } from '@/services/authService';

const router = useRouter();
const currentPassword = ref('');
const newPassword = ref('');
const confirmPassword = ref('');
const error = ref('');
const success = ref('');

const handleChangePassword = async () => {
  if (newPassword.value !== confirmPassword.value) {
    error.value = 'New passwords do not match';
    return;
  }
  try {
    console.log('Attempting to change password');
    const result = await changePassword(currentPassword.value, newPassword.value);
    console.log('Password change result:', result);
    success.value = 'Password changed successfully';
    currentPassword.value = '';
    newPassword.value = '';
    confirmPassword.value = '';
    setTimeout(() => {
      router.push('/');
    }, 2000);
  } catch (err) {
    console.error('Error in handleChangePassword:', err);
    error.value = err.response?.data?.error || 'Failed to change password. Please try again.';
  }
};
</script>

<template>
  <div class="change-password">
    <h2>Change Password</h2>
    <form @submit.prevent="handleChangePassword">
      <input v-model="currentPassword" type="password" placeholder="Current Password" required>
      <input v-model="newPassword" type="password" placeholder="New Password" required>
      <input v-model="confirmPassword" type="password" placeholder="Confirm New Password" required>
      <button type="submit">Change Password</button>
    </form>
    <p v-if="error" class="error">{{ error }}</p>
    <p v-if="success" class="success">{{ success }}</p>
  </div>
</template>

<style scoped>
/* ... vos styles ... */
</style>