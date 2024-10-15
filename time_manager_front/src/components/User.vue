<script setup>
import { ref, markRaw } from 'vue'
import {user, userId} from '@/components/utils'
import GetUser from './GetUser.vue';
import CreatUser from './CreatUser.vue';
import ModifyUser from './ModifyUser.vue';

const navValue = ref('GetUser')

const components = {
  GetUser: markRaw(GetUser),
  CreatUser: markRaw(CreatUser),
  ModifyUser: markRaw(ModifyUser)
};

const switchComponent = (component) => {
  navValue.value = component;
};
console.log(navValue)
</script>

<template>
    <div id="body">
      <div id="body-nav">
        <button @click="switchComponent('CreatUser')">Create User</button>
        <button @click="switchComponent('ModifyUser')">Modify User</button>
        <button @click="switchComponent('GetUser')">Get User</button>
      </div>
      <div id="user">
        <component :is="components[navValue]"></component>
      </div>
      <div id="userInformation" v-if="userId">
            <h2>User Information</h2>
            <p>User ID: {{ userId }}</p>
            <p>Email: {{ user.email }}</p>
            <p>Username: {{ user.username }}</p>
      </div>
    </div>
</template>

<style scoped>
#body {
    display: flex;
    background-image: linear-gradient(to right, #f8f8f8, #ede0e0);
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.225);
    height: 100%;
}

#body-nav, #user, #userInformation {
    flex: 1;
    height: 100%;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 20px;
    box-sizing: border-box;
}

#user{
  flex: 3;
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 20px;
  box-sizing: border-box;
}

#body-nav {
    background-color: #f8f8f8;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.225);
    border-top-left-radius: 20px;
    border-bottom-left-radius: 20px;
}

#userInformation {
    background-color: #f8f8f8;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.225);
    border-top-right-radius: 20px;
    border-bottom-right-radius: 20px;
}

h2 {
    font-size: 40px;
    margin-bottom: 20px;
}

button {
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
    width: 80%;
    margin: 10px 0;
}

button:hover {
    background-color: #f6efe8;
}

button:active {
    box-shadow: #422800 2px 2px 0 0;
    transform: translate(2px, 2px);
}
</style>