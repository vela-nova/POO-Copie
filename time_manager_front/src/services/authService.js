import { ref } from 'vue';
import api from './api';

export const isAuthenticated = ref(false);
export const currentUser = ref(null);

export const login = async (email, password) => {
  try {
    const response = await api.post('/login', { email, password });
    const { user, api_token } = response.data;
    localStorage.setItem('api_token', api_token);
    localStorage.setItem('userId', user.id);
    api.defaults.headers.common['Authorization'] = `Bearer ${api_token}`;
    isAuthenticated.value = true;
    currentUser.value = user;
    return user;
  } catch (error) {
    console.error('Login error:', error);
    throw error;
  }
};

export const register = async (username, email, password) => {
  try {
    const response = await api.post('/register', { user: { username, email, password } });
    const { user, api_token } = response.data;
    localStorage.setItem('api_token', api_token);
    localStorage.setItem('userId', user.id);
    api.defaults.headers.common['Authorization'] = `Bearer ${api_token}`;
    isAuthenticated.value = true;
    currentUser.value = user;
    return user;
  } catch (error) {
    console.error('Registration error:', error.response?.data || error.message);
    throw error;
  }
};
export const logout = async () => {
  try {
    await api.post('/logout');
  } catch (error) {
    console.error('Logout error:', error);
  } finally {
    localStorage.removeItem('api_token');
    delete api.defaults.headers.common['Authorization'];
    isAuthenticated.value = false;
    currentUser.value = null;
  }
};

export const checkAuth = async () => {
  const token = localStorage.getItem('api_token');
  if (token) {
    api.defaults.headers.common['Authorization'] = `Bearer ${token}`;
    try {
      const response = await api.get('/me');
      currentUser.value = response.data.data;
      isAuthenticated.value = true;
    } catch (error) {
      console.error('Auth check error:', error);
      await logout();
    }
  } else {
    isAuthenticated.value = false;
    currentUser.value = null;
  }
};
export const changePassword = async (currentPassword, newPassword) => {
  try {
    const response = await api.put('/change-password', { currentPassword, newPassword });
    return response.data;
  } catch (error) {
    console.error('Change password error:', error);
    if (error.response) {
      console.error('Error data:', error.response.data);
      console.error('Error status:', error.response.status);
    }
    throw error;
  }
};