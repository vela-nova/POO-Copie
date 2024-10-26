<script setup>
import { ref, onMounted, watch } from 'vue';
import { currentUser, checkAuth } from '@/services/authService';

const user = ref(null);

const fetchUserProfile = async () => {
  try {
    await checkAuth();
    user.value = currentUser.value;
  } catch (error) {
    console.error('Error fetching user profile:', error);
  }
};

onMounted(fetchUserProfile);

watch(currentUser, (newValue) => {
  user.value = newValue;
});
</script>

<template>
  <div class="profile">
    <h2>User Profile</h2>
    <div v-if="user">
      <p><strong>Username:</strong> {{ user.username }}</p>
      <p><strong>Email:</strong> {{ user.email }}</p>
      <p><strong>Role:</strong> {{ user.role }}</p>
    </div>
    <div v-else>
      <p>Loading profile...</p>
    </div>
    <router-link to="/change-password" class="change-password-btn">Change Password</router-link>
  </div>
</template>

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