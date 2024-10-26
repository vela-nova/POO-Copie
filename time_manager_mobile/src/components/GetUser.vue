
<template>
  <div>
    <div id="body-part">
      <div id="user">
        <h2>Get User</h2>
      </div>
      <div id="userInput">
        <div>
          <input id="email" v-model="searchEmail" type="email" placeholder="Enter email">
        </div>
        <div>
          <input id="username" v-model="searchUsername" type="text" placeholder="Enter username">
        </div>
        <button @click="handleFetchUser">Fetch User</button>
      </div>
      <div v-if="user" id="userDetails">
        <h3>User Details</h3>
        <p>ID: {{ userId }}</p>
        <p>Username: {{ user.username }}</p>
        <p>Email: {{ user.email }}</p>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref } from 'vue';
import { fetchUser, email, username, user, userId } from '../services/userService';

const searchEmail = ref('');
const searchUsername = ref('');

const handleFetchUser = async () => {
  email.value = searchEmail.value;
  username.value = searchUsername.value;
  await fetchUser();
};
</script>
<style scoped>
/* Vos styles existants */
#userDetails {
  margin-top: 20px;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
}
</style>