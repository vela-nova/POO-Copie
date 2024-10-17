<script setup>
import{creatUsername, creatEmail, createUser} from '@/services/userService'
</script>

<template>
    <div class="create-user">
        <h1>Create User</h1>
        <form @submit.prevent="createUser">
            <div>
                <label for="username">Username:</label>
                <input type="text" id="username" v-model="creatUsername" required>
            </div>
            <div>
                <label for="email">Email:</label>
                <input type="email" id="email" v-model="creatEmail" required>
            </div>
            <button type="submit">Create</button>
        </form>
    </div>
</template>



<style scoped>

.create-user {
    width: 50%;
    margin: 0 auto;
    border-radius: 4px;
    display: flex;
    flex-direction: column;
    text-align: center;
}

.create-user h1 {
    text-align: center;
    font-size: 40px;
}

.create-user form div {
    margin-bottom:10%;
}

.create-user label {
    display: block;
    margin-bottom: 5px;
    text-align: left;
}

.create-user input {
    width: 100%;
    padding: 10px;
    box-sizing: border-box;
}


.create-user button{
    background-color: #fbeee0;
    border: 2px solid #422800;
    border-radius: 30px;
    box-shadow: #422800 2px 2px 0 0;
    color: #422800;
    cursor: pointer;
    display: inline-block;
    font-weight: 600;
    font-size: 18px;
    padding: 0 18px;
    line-height: 50px;
    text-align: center;
    text-decoration: none;
    user-select: none;
    -webkit-user-select: none;
    touch-action: manipulation;
    min-width: 30%;
  
}

button:hover {
  background-color: #f6efe8;
}

button:active {
  box-shadow: #422800 2px 2px 0 0;
  transform: translate(2px, 2px);
}
</style>