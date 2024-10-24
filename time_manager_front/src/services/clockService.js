import { ref } from 'vue';
import api from './api';

const userId = ref(localStorage.getItem('userId'));

export const clockTime = ref('');

export const creatClock = async (clockStatus) => {
  try {
    const response = await api.post(`/clocks/${userId.value}`, {
      clock: { status: clockStatus },
      userID: userId.value
    });
    return response.data.data;
  } catch (error) {
    console.error('Error creating clock:', error);
  }
};

export const getClocks = async (userId) => {
  try {
    const response = await api.get(`/clocks/${userId}`);
    return response.data.data;
  } catch (error) {
    console.error('Error fetching clocks:', error);
    throw error;
  }
};