<template>
  <div id="app">
    <div v-if="isAuthenticated" class="authenticated-content">
      <div id="header">
        <div id="header-title">
          <img id="logo" :src="logo" alt="Logo" />
          <h2>Time Manager</h2>
        </div>
        <nav id="nav">
          <router-link to="/" custom v-slot="{ navigate }">
            <button @click="navigate">
              <font-awesome-icon icon="fa-solid fa-chart-line" /> Dashboard
            </button>
          </router-link>
          <router-link to="/profile" custom v-slot="{ navigate }">
            <button @click="navigate">
              <font-awesome-icon icon="fa-solid fa-user" /> Profile
            </button>
          </router-link>
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
    <div v-else class="unauthenticated-content">
      <div class="auth-links">
        <router-link to="/login">Login</router-link> |
        <router-link to="/register">Register</router-link>
      </div>
      <router-view></router-view>
    </div>
  </div>  
</template>

<script setup>
import { onMounted, watch } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import logo from './assets/logo.png';
import profileLogo from './assets/ProfileLogo.png';
import { isAuthenticated, checkAuth, logout } from './services/authService';

const router = useRouter();
const route = useRoute();

onMounted(async () => {
  await checkAuth();
  if (isAuthenticated.value && (route.path === '/login' || route.path === '/register')) {
    router.push('/');
  }
});

watch(isAuthenticated, (newValue) => {
  if (newValue && (route.path === '/login' || route.path === '/register')) {
    router.push('/');
  }
});

const handleLogout = async () => {
  await logout();
  router.push('/login');
};
</script>

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

.unauthenticated-content {
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
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
  border-radius: 8px;
  font-size: 1rem;
  cursor: pointer;
  width: 100%;
  text-align: left;
  transition: background-color 0.3s, color 0.3s;
}

#nav button:hover, #nav button:focus {
  background-color: #0177FB;
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
  margin-bottom: 20px;
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