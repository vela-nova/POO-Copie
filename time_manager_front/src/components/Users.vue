<script setup>
import { ref, onMounted, watch } from 'vue';
import { getUsers } from '@/services/userService'; // Assurez-vous que le chemin d'importation est correct
import User from './User.vue';

const users = ref([]);
const loading = ref(true);
const error = ref(null);

onMounted(async () => {
  try {
    users.value = await getUsers();
    loading.value = false;
  } catch (err) {
    error.value = 'Failed to load users';
    loading.value = false;
  }
});



</script>

<template>
  <div id="users">
    <h2>User List</h2>
    <div id="userlistWrapper">
      <ul>
        <div class="userWrapper" v-for="user in users" :key="user.id">
          <User 
            :id="user.id"
            :mailadress="user.email" 
            :username="user.username"
            :check-status="user.check_status==null?false:user.check_status" >
          </User>
        </div>
      </ul>
    </div>
  </div>
</template>

<style scoped>

.userWrapper {
  width: calc(100%-2em);
  min-width: 18em;
  height: 6em;
  border-bottom: 2px solid rgba(255, 255, 255, 0.486) ;
  margin-right: 1em;
  margin-left: 1em;
  margin-bottom: 0.5em;

}

.userWrapper:last-of-type{
  border: none;
}

#userlistWrapper {
  overflow: scroll;
  background-color: grey;
  border: 20px solid grey;
  border-radius: 10px;
  margin: 0 auto;
  text-align: center;
  width: 80%;
  max-width: 600px;
  max-height: 85%;
}
#users {
  height: calc(100% - 40px);
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
}

h2 {
  color: #333;
  margin-bottom: 20px;
}

ul {
  list-style-type: none;
  padding: 0;
}
</style>