<script setup>
import { ref, onMounted } from 'vue';
import { updateUser, deleteUser, user, userId, email, username } from '@/services/userService';

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
  email.value = updateEmail.value;
  username.value = updateUsername.value;
  try {
    await updateUser();
    errorMessage.value = 'User updated successfully';
  } catch (error) {
    errorMessage.value = `Failed to update user: ${error.message}`;
  }
};

const handleDeleteUser = async () => {
  errorMessage.value = '';
  if (confirm('Are you sure you want to delete this user?')) {
    try {
      await deleteUser();
      errorMessage.value = 'User deleted successfully';
    } catch (error) {
      errorMessage.value = `Failed to delete user: ${error.message}`;
    }
  }
};
</script>

<template>
  <div class="modify-user">
    <h1>Modify User</h1>
    <form @submit.prevent="handleUpdateUser">
      <div>
        <label for="username">Username:</label>
        <input type="text" id="username" v-model="updateUsername" required>
      </div>
      <div>
        <label for="email">Email:</label>
        <input type="email" id="email" v-model="updateEmail" required>
      </div>
      <button type="submit">Update</button>
    </form>
    <button @click="handleDeleteUser" class="delete-button">Delete User</button>
    <p v-if="errorMessage" :class="{ 'error': errorMessage.includes('Failed'), 'success': !errorMessage.includes('Failed') }">
      {{ errorMessage }}
    </p>
  </div>
</template>

<style scoped>

.error {
  color: red;
}
.success {
  color: green;
}
</style>