
import axios from 'axios';

const BASE_URL = import.meta.env.VITE_BACKEND_URL_MOBILE || 'http://10.0.2.2:4000/api';
console.log('BASE_URL:', BASE_URL);
console.log('Environment:', import.meta.env);

const api = axios.create({
  baseURL: BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});


api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('api_token');
    if (token) {
      config.headers['Authorization'] = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

export default api;