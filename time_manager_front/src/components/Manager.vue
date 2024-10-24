<script setup>
import { ref, onMounted, computed } from 'vue';
import { getUsers, updateUser, updateUserRole, deleteUser, createUser } from '@/services/userService';
import { currentUser } from '@/services/authService';

const users = ref([]);
const loading = ref(true);
const error = ref(null);
const editingUser = ref(null);
const newUser = ref({ username: '', email: '', role: 'employee' });
const showAddUserForm = ref(false);

const isAdmin = computed(() => currentUser.value?.role === 'admin');
const isManagerOrAdmin = computed(() => ['manager', 'admin'].includes(currentUser.value?.role));

const fetchUsers = async () => {
  try {
    const fetchedUsers = await getUsers();
    console.log('Fetched users:', fetchedUsers);
    users.value = fetchedUsers;
    loading.value = false;
  } catch (err) {
    console.error('Error in fetchUsers:', err);
    error.value = 'Failed to load users: ' + (err.message || 'Unknown error');
    loading.value = false;
  }
};

const startEditing = (user) => {
  editingUser.value = { ...user, originalRole: user.role };
};

const cancelEditing = () => {
  editingUser.value = null;
};

const saveUserInfo = async () => {
  if (!editingUser.value) return;
  
  try {
    const updatedUser = await updateUser(editingUser.value.id, {
      username: editingUser.value.username,
      email: editingUser.value.email
    });
    
    console.log('Updated user info:', updatedUser);
    updateUserInList(updatedUser);
  } catch (err) {
    console.error('Error in saveUserInfo:', err);
    error.value = `Failed to update user info: ${err.message || 'Unknown error'}`;
  }
};

const saveUserRole = async () => {
  if (!editingUser.value || !isAdmin.value) return;
  
  try {
    console.log('Attempting to update role for user:', editingUser.value.id, 'to', editingUser.value.role);
    const updatedUser = await updateUserRole(editingUser.value.id, editingUser.value.role);
    
    console.log('Updated user role:', updatedUser);
    updateUserInList(updatedUser);
  } catch (err) {
    console.error('Error in saveUserRole:', err);
    error.value = `Failed to update user role: ${err.message || 'Unknown error'}`;
  }
};

const updateUserInList = (updatedUser) => {
  const index = users.value.findIndex(u => u.id === updatedUser.id);
  if (index !== -1) {
    users.value[index] = { ...updatedUser };
  }
  editingUser.value = null;
};

const deleteUserHandler = async (userId) => {
  if (!isAdmin.value) {
    error.value = 'You do not have permission to delete users';
    return;
  }
  try {
    console.log('Attempting to delete user:', userId);
    await deleteUser(userId);
    console.log('User deleted successfully');
    users.value = users.value.filter(user => user.id !== userId);
  } catch (err) {
    console.error('Error in deleteUserHandler:', err);
    error.value = 'Failed to delete user: ' + (err.message || 'Unknown error');
  }
};

const createNewUser = async () => {
  if (!isAdmin.value) return;
  
  try {
    const newUserData = {
      username: newUser.value.username,
      email: newUser.value.email,
      role: newUser.value.role
    };
    const createdUser = await createUser(newUserData);
    console.log('Created new user:', createdUser);
    users.value.push(createdUser);
    showAddUserForm.value = false;
    newUser.value = { username: '', email: '', role: 'employee' };
  } catch (err) {
    console.error('Error in createUser:', err);
    error.value = `Failed to create user: ${err.message || 'Unknown error'}`;
  }
};

onMounted(fetchUsers);
</script>

<template>
  <div class="manager">
    <h2>User Management</h2>
    <div v-if="loading">Loading users...</div>
    <div v-if="error" class="error">{{ error }}</div>
    <table v-if="!loading && !error">
      <thead>
        <tr>
          <th>Username</th>
          <th>Email</th>
          <th>Role</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="user in users" :key="user.id">
          <template v-if="editingUser && editingUser.id === user.id">
            <td><input v-model="editingUser.username" /></td>
            <td><input v-model="editingUser.email" /></td>
            <td>
              <select v-if="isAdmin" v-model="editingUser.role">
                <option value="employee">Employee</option>
                <option value="manager">Manager</option>
                <option value="admin">Admin</option>
              </select>
              <span v-else>{{ editingUser.role }}</span>
            </td>
            <td>
              <button @click="saveUserInfo">Save Info</button>
              <button v-if="isAdmin" @click="saveUserRole">Save Role</button>
              <button @click="cancelEditing">Cancel</button>
            </td>
          </template>
          <template v-else>
            <td>{{ user.username }}</td>
            <td>{{ user.email }}</td>
            <td>{{ user.role || 'N/A' }}</td>
            <td>
              <button v-if="isManagerOrAdmin" @click="startEditing(user)">Edit</button>
              <button 
                v-if="isAdmin && user.id !== currentUser.value?.id" 
                @click="deleteUserHandler(user.id)"
              >
                Delete
              </button>
            </td>
          </template>
        </tr>
      </tbody>
    </table>
    
    <div v-if="isAdmin" class="add-user-section">
      <button v-if="!showAddUserForm" @click="showAddUserForm = true">Add New User</button>
      <form v-else @submit.prevent="createNewUser">
        <input v-model="newUser.username" placeholder="Username" required>
        <input v-model="newUser.email" type="email" placeholder="Email" required>
        <select v-model="newUser.role">
          <option value="employee">Employee</option>
          <option value="manager">Manager</option>
          <option value="admin">Admin</option>
        </select>
        <button type="submit">Create User</button>
        <button @click="showAddUserForm = false">Cancel</button>
      </form>
    </div>
  </div>
</template>

<style scoped>
.manager {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
}

h2 {
  color: #333;
  margin-bottom: 20px;
}

table {
  width: 100%;
  border-collapse: collapse;
}

th, td {
  text-align: left;
  padding: 12px;
  border-bottom: 1px solid #ddd;
}

th {
  background-color: #f2f2f2;
  font-weight: bold;
}

input, select {
  width: 100%;
  padding: 8px;
  margin: 2px 0;
  box-sizing: border-box;
}

button {
  padding: 5px 10px;
  margin-right: 5px;
  background-color: #007bff;
  color: white;
  border: none;
  border-radius: 3px;
  cursor: pointer;
}

button:hover {
  background-color: #0056b3;
}

button:last-child {
  background-color: #dc3545;
}

button:last-child:hover {
  background-color: #c82333;
}

.error {
  color: red;
  margin-bottom: 10px;
}

.add-user-section {
  margin-top: 20px;
}

.add-user-section form {
  display: flex;
  flex-direction: column;
  gap: 10px;
  max-width: 300px;
}

.add-user-section input,
.add-user-section select {
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
}

.add-user-section button {
  padding: 8px 16px;
  background-color: #28a745;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.add-user-section button:hover {
  background-color: #218838;
}

.add-user-section button[type="submit"] {
  background-color: #007bff;
}

.add-user-section button[type="submit"]:hover {
  background-color: #0056b3;
}
</style>