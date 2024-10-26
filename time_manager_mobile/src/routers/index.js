import { createRouter, createWebHistory } from 'vue-router';
import UserLogin from '../components/Auth/UserLogin.vue';
import UserRegister from '../components/Auth/UserRegister.vue';
import ChangePassword from '../components/Auth/ChangePassword.vue';
import UserDashboard from '../components/UserDashboard.vue';
import UserProfile from '../components/UserProfile.vue';
import { isAuthenticated } from '../services/authService'; // Assurez-vous que ce chemin est correct

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/',
      name: 'Dashboard',
      component: UserDashboard,
      meta: { requiresAuth: true }
    },
    {
      path: '/profile',
      name: 'Profile',
      component: UserProfile,
      meta: { requiresAuth: true }
    },
    {
      path: '/login',
      name: 'Login',
      component: UserLogin
    },
    {
      path: '/register',
      name: 'Register',
      component: UserRegister
    },
    {
      path: '/change-password',
      name: 'ChangePassword',
      component: ChangePassword,
      meta: { requiresAuth: true }
    }
  ]
});

router.beforeEach((to, from, next) => {
  if (to.meta.requiresAuth && !isAuthenticated.value) {
    next('/login');
  } else if ((to.name === 'Login' || to.name === 'Register') && isAuthenticated.value) {
    next('/');
  } else {
    next();
  }
});

export default router;