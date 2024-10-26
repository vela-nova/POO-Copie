import { ref } from 'vue';
import api from './api';

export const email = ref('');
export const username = ref('');
export const user = ref(null);
export const userId = ref(null);
export const creatUsername = ref('');
export const creatEmail = ref('');

export const setUserId = (id) => {
  userId.value = id;
};

export const fetchUser = async () => {
  try {
    const response = await api.get('/users', {
      params: { email: email.value, username: username.value }
    });
    if (response.data.data.length > 0) {
      userId.value = response.data.data[0].id;
      user.value = response.data.data[0];
    } else {
      user.value = null;
      userId.value = null;
    }
  } catch (error) {
    console.error('Error fetching user:', error);
    user.value = null;
    userId.value = null;
  }
};

export const getUsers = async () => {
  try {
    const response = await api.get('/users');
    return response.data.data || [];
  } catch (error) {
    console.error('Error fetching users:', error);
    throw error;
  }
};

export const createUser = async (userData) => {
  try {
    const response = await api.post('/users', { user: { ...userData, password: 'default_password' } });
    return response.data.data;
  } catch (error) {
    console.error('Error creating user:', error);
    if (error.response) {
      console.error('Error data:', error.response.data);
      console.error('Error status:', error.response.status);
      console.error('Error headers:', error.response.headers);
    }
    throw error;
  }
};

export const updateUser = async (userId, userData) => {
  try {
    const response = await api.put(`/users/${userId}`, { user: userData });
    return response.data.data;
  } catch (error) {
    console.error('Error updating user:', error);
    if (error.response) {
      console.error('Error data:', error.response.data);
      console.error('Error status:', error.response.status);
      console.error('Error headers:', error.response.headers);
    }
    throw error;
  }
};

export const updateUserRole = async (userId, newRole) => {
  try {
    const response = await api.put(`/users/${userId}/role`, { role: newRole });
    return response.data.data;
  } catch (error) {
    console.error('Error updating user role:', error);
    if (error.response) {
      console.error('Error data:', error.response.data);
      console.error('Error status:', error.response.status);
      console.error('Error headers:', error.response.headers);
    }
    throw error;
  }
};

export const deleteUser = async (userId) => {
  try {
    const response = await api.delete(`/users/${userId}`);
    return true;
  } catch (error) {
    console.error('Error deleting user:', error);
    if (error.response) {
      console.error('Error data:', error.response.data);
      console.error('Error status:', error.response.status);
      console.error('Error headers:', error.response.headers);
    }
    throw error;
  }
};