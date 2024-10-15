
<script setup>
import { fetchUser, username, email } from './utils';

</script>

<template>
    <div>
        <div id="body-part">
        <div id="user">
            <h2>User</h2>
        </div>
        <div id="userInput">
            <div>
                <input id="email" v-model="email" type="email" placeholder="Enter your email">
            </div>
            <div>
                    <input id="username" v-model="username" type="text" placeholder="Enter your username">
            </div>
            <button @click="fetchUser">Fetch User</button>

        </div>
        
      </div>
    </div>
</template>


<style scoped>

#body-part{
  display: flex;
  flex-direction: column;
  align-items: center;
 
}

input {
    width: 200px;
    padding: 12px;
    font-size: 16px;
    margin: 10px 0 0 0 ;
    border: none;
}


h2{
    font-size: 40px;
    margin: 10% 0 10% 0;
}

#user {
    margin: 10px;
    
}

button{
  background-color: #fbeee0;
  border: 2px solid #422800;
  border-radius: 30px;
  box-shadow: #422800 2px 2px 0 0;
  color: #422800;
  cursor: pointer;
  display: inline-block;
  font-weight: 600;
  font-size: 18px;
  padding: 0 18px;
  line-height: 50px;
  text-align: center;
  text-decoration: none;
  user-select: none;
  -webkit-user-select: none;
  touch-action: manipulation;
  min-width: 30%;
  margin: 10% 0 0 17%;
}

button:hover {
  background-color: #f6efe8;
}

button:active {
  box-shadow: #422800 2px 2px 0 0;
  transform: translate(2px, 2px);
}
</style>