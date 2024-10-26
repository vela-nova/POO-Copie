import Login from '@/components/Auth/Login.vue';
import Register from '@/components/Auth/Register.vue';
import ChangePassword from '@/components/Auth/ChangePassword.vue';
import Dashboard from '@/components/Dashboard.vue';
import Users from '@/components/Users.vue';
import Profile from '@/components/Profile.vue';
import Manager from '@/components/Manager.vue';
import { createRouter, createWebHistory } from 'vue-router'
import { isAuthenticated, checkAuth } from '@/services/authService'
import WorkingTimes from '@/components/WorkingTimes.vue';

const router = createRouter({
  history: createWebHistory(),
  routes :[
    {
      path: '/',
      name: 'Dashboard',
      component: Dashboard,
      meta: { requiresAuth: true }
    },
    {
      path: '/users',
      name: 'Users',
      component: Users,
      meta: { requiresAuth: true }
    },
    {
      path: '/profile',
      name: 'Profile',
      component: Profile,
      meta: { requiresAuth: true }
    },
    {
      path: '/manager',
      name: 'Manager',
      component: Manager,
      meta: { requiresAuth: true }
    },
    {
      path: '/login',
      name: 'Login',
      component: Login
    },
    {
      path: '/register',
      name: 'Register',
      component: Register
    },
    {
      path: '/change-password',
      name: 'ChangePassword',
      component: ChangePassword,
      meta: { requiresAuth: true }
    },
    {
      path: '/workingTimes',
      name: 'WorkingTimes',
      component: WorkingTimes,
      meta: { requiresAuth: true }
    }
  ]
})

router.beforeEach(async (to, from, next) => {
  await checkAuth()
  if (to.meta.requiresAuth && !isAuthenticated.value) {
    next('/login')
  } else {
    next()
  }
})

export default router



