<script setup>
import { userId } from './utils';
import { clockStatus, creatClock, clockTime, switchComponent } from './utils';

const clock = async () => {
    if (clockStatus.value) {
        clockTime.value = null;
    } else {
        clockTime.value = new Date().toLocaleString();
    }
    clockStatus.value = !clockStatus.value;
    await creatClock()
};

const refresh = () => {
    clockTime.value = null;
    clockStatus.value = false;
};


</script>

<template>
    <div id="clockManager">
        <div v-if="userId === null">
            <h2>Selectionner un Utilisateur</h2>
            <button @click="switchComponent('User')">Vers User</button>
        </div>
        <h1 v-if="userId !== null">Clock Manager for User: {{ userId }}</h1>
        <div v-if="userId !== null">
            <p v-if="clockTime">Start Time: {{ clockTime }}</p>
            <p v-else>No work period in progress</p>
            <p>Clock In Status: {{ clockStatus ? 'Active' : 'Inactive' }}</p>
            <button @click="clock">{{ clockStatus ? 'Clock Out' : 'Clock In' }}</button>
            <button @click="refresh = null">Reset</button>
        </div>
    </div>
</template>

<style scoped>
    #clockManager {
        width: 50%;
        margin: 0 auto;
        border-radius: 4px;
        display: flex;
        flex-direction: column;
        text-align: center;
    }
   
    button{
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
    margin: 10% 0 0 17%;
    }

    button:hover {
    background-color: #f6efe8;
    }

    button:active {
    box-shadow: #422800 2px 2px 0 0;
    transform: translate(2px, 2px);
    }
</style>
