<script setup>
import { onMounted, computed } from 'vue';
import { useRouter } from 'vue-router';
import logo from './assets/logo.png';
import profileLogo from './assets/ProfileLogo.png';
import { isAuthenticated, checkAuth, logout, currentUser } from '@/services/authService';

const router = useRouter();

onMounted(checkAuth);

const handleLogout = () => {
  logout();
  router.push('/login');
};

const currentRoute = computed(
  () => router.currentRoute.value.path
);

const isEmployee = computed(() => currentUser.value?.role === 'employee');
</script>


<template>
  <div id="app">

    <div v-if="isAuthenticated" class="authenticated-content">
      <div id="header">
        <div id="header-title">
          <img id="logo" :src="logo" alt="Logo" />
          <h2>Gotham Time Manager</h2>
        </div>
        <nav id="nav">
          <router-link to="/" custom v-slot="{ navigate }">
            <button @click="navigate" :class="{ selected: currentRoute=='/' }">
              <font-awesome-icon icon="fa-solid fa-chart-line" /> Dashboard
            </button>
          </router-link>
          <router-link to="/profile" custom v-slot="{ navigate }">
            <button @click="navigate" :class="{ selected: currentRoute=='/profile' }">
              <font-awesome-icon icon="fa-solid fa-user" /> Profile
            </button>
          </router-link>
          <router-link to="/workingTimes" custom v-slot="{ navigate }">
            <button @click="navigate" :class="{ selected: currentRoute=='/workingTimes' }">
              <font-awesome-icon icon="fa-solid fa-calendar-days" /> Working Times
            </button>
          </router-link>
          <template v-if="!isEmployee">
            <router-link to="/users" custom v-slot="{ navigate }">
              <button @click="navigate" :class="{ selected: currentRoute=='/users' }">
                <font-awesome-icon icon="fa-solid fa-users" /> Users
              </button>
            </router-link>
            <router-link to="/manager" custom v-slot="{ navigate }">
              <button @click="navigate" :class="{ selected: currentRoute=='/manager' }">
                <font-awesome-icon icon="fa-solid fa-clipboard" /> Manager
              </button>
            </router-link>
          </template>
        </nav>
      </div>
      <div id="body">
        <div id="body-header">
          <div class="header-right">
            <img id="profile-logo" :src="profileLogo" alt="profileLogo" />
            <button @click="handleLogout" class="logout-button">
              <font-awesome-icon icon="fa-solid fa-sign-out-alt" /> Logout
            </button>
          </div>
        </div>
        <div id="body-content">
          <router-view></router-view>
        </div>
      </div>
    </div>

    <router-view v-if="!isAuthenticated"></router-view>
  </div>  
</template>

<style scoped>
#app {
  display: flex;
  background-color: #f0f2f5;
  min-height: 100vh;
  width: 100vw;
}

.authenticated-content {
  display: flex;
  width: 100%;
}

#header {
  width: 250px;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background-color: #ffffff;
  box-shadow: 2px 0 5px rgba(0,0,0,0.1);
}

#header-title {
  display: flex;
  align-items: center;
  padding: 20px;
}

#header-title h2 {
  font-size: 1.5rem;
  margin-left: 10px;
}

#logo {
  width: 50px;
  height: 50px;
}

#nav {
  display: flex;
  flex-direction: column;
  padding: 20px 0;
}

#nav button {
  margin: 5px 0;
  padding: 10px 20px;
  border: none;
  background-color: transparent;
  font-size: 1rem;
  cursor: pointer;
  width: 100%;
  text-align: left;
  transition: background-color 0.3s, color 0.3s;
}

#nav button:hover, #nav button:focus, .selected {
  background-color: #0177FB !important;
  color: #ffffff;
}

#body {
  flex-grow: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

#body-header {
  height: 60px;
  background-color: #ffffff;
  display: flex;
  justify-content: flex-end;
  align-items: center;
  padding: 0 20px;
  box-shadow: 0 2px 5px rgba(0,0,0,0.1);
}

.header-right {
  display: flex;
  align-items: center;
}

#profile-logo {
  width: 36px;
  height: 36px;
  margin-right: 15px;
  border-radius: 50%;
}

.logout-button {
  background-color: #ff4136;
  color: white;
  border: none;
  padding: 8px 16px;
  border-radius: 4px;
  cursor: pointer;
  font-size: 0.9rem;
  transition: background-color 0.3s;
}

.logout-button:hover {
  background-color: #ff1a1a;
}

#body-content {
  flex-grow: 1;
  overflow-y: auto;
  padding: 20px;
}

.auth-links {
  position: absolute;
  top: 20px;
  right: 20px;
}

.auth-links a {
  margin: 0 10px;
  text-decoration: none;
  color: #333;
}

.auth-links a:hover {
  text-decoration: underline;
}
</style>