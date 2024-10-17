import api from './api';

export async function getWorkingTimes(userId, start, end) {
  console.log('Fetching working times with:', { userId, start, end });
  try {
    const response = await api.get(`/workingtime/${userId}`, {
      params: { start, end }
    });
    console.log('API Response:', response);
    return response.data.data;
  } catch (error) {
    console.error('Error fetching working times:', error);
    throw error;
  }
}
export const getWorkingTimesUserId = async (userId) => {
  try {
    const response = await api.get(`/workingtimes/${userId}`);
    return response.data.data;
  } catch (error) {
    console.error('Error fetching working times:', error);
    throw error;
  }
};

export async function getWorkingTime(userId, wtId) {
  try {
    const response = await api.get(`/workingtime/${userId}/${wtId}`);
    return response.data.data;
  } catch (error) {
    console.error('Error fetching specific working time:', error);
    throw error;
  }
}

export async function createWorkingTime(userId, workingTimeData) {
  try {
    const response = await api.post(`/workingtime/${userId}`, { working_time: workingTimeData });
    return response.data.data;
  } catch (error) {
    console.error('Error creating working time:', error);
    throw error;
  }
}

export async function updateWorkingTime(wtId, workingTimeData) {
  try {
    const response = await api.put(`/workingtime/${wtId}`, { working_time: workingTimeData });
    return response.data.data; 
  } catch (error) {
    console.error('Error updating working time:', error);
    throw error;
  }
}

export async function deleteWorkingTime(wtId) {
  try {
    const response = await api.delete(`/workingtime/${wtId}`);
    return response.data;
  } catch (error) {
    console.error('Error deleting working time:', error);
    throw error;
  }
}