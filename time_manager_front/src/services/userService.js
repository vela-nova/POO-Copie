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
    return response.data.data;
  } catch (error) {
    console.error('Error fetching users:', error);
    throw error;
  }
};
export const createUser = async () => {
  try {
    const response = await api.post('/users', {
      user: { email: creatEmail.value, username: creatUsername.value }
    });
    userId.value = response.data.data.id;
    user.value = response.data.data;
  } catch (error) {
    console.error('Error creating user:', error);
  }
};

export const updateUser = async () => {
  try {
    console.log('Updating user with data:', { email: email.value, username: username.value });
    const response = await api.put(`/users/${userId.value}`, {
      user: { email: email.value, username: username.value }
    });
    user.value = response.data.data;
  } catch (error) {
    console.error('Error updating user:', error.response?.data || error.message);
  }
};

export const deleteUser = async () => {
  try {
    await api.delete(`/users/${userId.value}`);
    user.value = null;
    userId.value = null;
    email.value = '';
    username.value = '';
  } catch (error) {
    console.error('Error deleting user:', error.message);
    if (error.response) {
      console.error('Server responded with:', error.response.data);
    }
  }
};