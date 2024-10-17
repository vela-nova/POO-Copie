// import { ref, markRaw } from 'vue'
// import axios from 'axios';
// import WorkingTimes from './WorkingTimes.vue';
// import User from './User.vue';
// import ChartManager from './ChartManager.vue';
// import ClockManager from './ClockManager.vue';


// const api = "http://localhost:4000/api"
// export const email = ref('')
// export const username = ref('')
// export const user = ref(null)
// export const userId = ref(null)
// export const creatUsername = ref('')
// export const creatEmail = ref('')
// export const clockTime = ref('')
// export const clockStatus = ref(false)

// export const switchComponent = (component) => {
//   currentComponent.value = component;
// };

// export const components = {
//   WorkingTimes: markRaw(WorkingTimes),
//   User: markRaw(User),
//   ChartManager: markRaw(ChartManager),
//   ClockManager: markRaw(ClockManager)
// };

// export const currentComponent = ref('WorkingTimes');


// export const fetchUser = async () => {
//   try {
//     const response = await axios.get('http://localhost:4000/api/users', {
//       params: {
//         email: email.value,
//         username: username.value
//       }
//     })
//     userId.value = response.data.data[0].id
//     user.value = response.data.data[0]
//   } catch (error) {
//     console.error('Error fetching user:', error)
//   }
// }

// export const createUser = async () => {
//     try {
//         const response = await axios.post('http://localhost:4000/api/users', {
//             user :{

//                 email: creatEmail.value,
//                 username: creatUsername.value
//             }
//         })
//         userId.value = response.data.data.id
//         user.value = response.data.data
//     } catch (error) {
//         console.error('Error creating user:', error)
//     }
// }

// export const updateUser = async () => {
//     try {
//         const response = await axios.put(`http://localhost:4000/api/users/${userId.value}`, {
//             user :{
//                 email: email.value,
//                 username: username.value
//             }
//         })
//         user.value = response.data.data
//     } catch (error) {
//         console.error('Error updating user:', error)
//     }
// }

// export const creatClock = async () => {
//   console.log(userId.value)
//   try {
//       const response = await axios.post(`http://localhost:4000/api/clocks/${userId.value}`, {
//         clock: {
//           status: clockStatus.value
//         },
//         userID: userId.value
//       });
//       user.value = response.data.data;
//   } catch (error) {
//       console.error('Error creating clock:', error);
//   }
// }

// export async function getWorkingTimes(userId, start, end) {
//     const url = `${api}/workingtime/${userId}?start=${start}&end=${end}`;

//     try {
//         const response = await axios.get(url);
//         console.log(response.data.data);
//         return response.data.data;
//     } catch (error) {
//         console.log(error);
//     }
// }

// export async function deleteWorkingTime(wtId) {
//     const url = `${api}/workingtime/${wtId}`

//     try {
//         const response = await axios.delete(url);
//         console.log(response.data);
//         return response.data;
//     } catch (error) {
//         console.log(error);
//     }
// }
