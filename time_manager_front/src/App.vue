<script setup>
import logo from './assets/logo.png';
import { switchComponent, components, currentComponent } from './components/utils';

</script>

<template>
  <div id="app">
    <div id="header">
      <img id="logo" :src="logo" alt="Logo" />
      <h1 id="header-title">Time Manager</h1>
      <nav id="header-nav">
        <button @click="switchComponent('WorkingTimes')">Working Times</button>
        <button @click="switchComponent('ClockManager')">Clock Manager</button>
        <button @click="switchComponent('ChartManager')">Chart Manager</button>
        <button @click="switchComponent('User')">User</button>
      </nav>
    </div>
    <div id="header-lign"></div>
    <div id="body">
      <component :is="components[currentComponent]"></component>
    </div>
  </div>  
</template>

<style scoped>
#header {
  height: 20%;
  width: 100%;
  display: flex;
  align-items: center;
}

#logo {
  width: 200px;
  height: 200px;
  margin: 0 0 0 2%; 
}

#header-lign {
  width: 90%;
  height: 2px;
  background-color: #422800;
}

#header-title {
  margin: 0 0 0 1%;
}

#header-nav {
  display: flex;
  gap: 1rem;
  width: 38%;
  margin: 0 2% 0 26%;
}

#header-nav button {
  padding: 0.5rem 1rem;
  border: none;
  background-color: #f0f0f0;
  cursor: pointer;
  border-radius: 5px;
}

#header-nav button:hover {
  background-color: #e0e0e0;
}

#header-User {
  margin: 0 5% 0 0;
}

button{
  background-color: #fbeee0;
  border: 2px solid #422800;
  border-radius: 30px;
  box-shadow: #422800 4px 4px 0 0;
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
  background-color: #fff;
}

button:active {
  box-shadow: #422800 2px 2px 0 0;
  transform: translate(2px, 2px);
}
button:focus {
  box-shadow: rgba(0, 0, 0, .5) 0 0 0 3px;
}
#body {
  height: 90%;
  min-width: 98%;
  display: flex;
  align-items: center;
  border-radius: 20px;
  
}

#app {
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  align-items: center;
  background-image: linear-gradient(to right, #efefef, #ddd2d2);
  height: 100vh;
}
</style>