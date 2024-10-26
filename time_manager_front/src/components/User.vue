<script setup>
import { email, user } from '@/services/userService';



const props = defineProps({
    id: {
        type: Number,
        required: true
    },
    mailadress: {
        type: String,
        required: true
    },
    username: {
        type: String,
        required: true
    },
    checkStatus: {
      type: Boolean,
      required: true
    }
});
</script>


<template>

  <div id="usermain">
    <div class="segment" id="userinfo">
      <font-awesome-icon icon="fa-solid fa-user" class="userinfoicon" :class="{green: checkStatus}" />
      <div>
        <p><b>Name : </b>{{ username }}</p>
        <p><b>Email : </b>{{ mailadress }}</p>
      </div>
    </div>
    <router-link to="/" custom v-slot="{ navigate }">
      <div class="segment" id="userActions" @click="navigate" >
        <font-awesome-icon icon="fa-solid fa-chart-line" /> 
      </div>
    </router-link>
  </div>
</template>


<style scoped>
.userinfoicon{
  height:1.5em;
  width: 1.5em;
  padding: 1em;
  color:  crimson;
}
.green{
  color: #90ee90;
}
#usermain{
  height: calc(100% - 0.5em);
  width: 100%;
  padding-bottom: 0.5em;
  display: flex;
  overflow: hidden;
}

#userActions {
  display: flex;
  flex-direction: column;
  width: fit-content;
  margin-left: 1em;
  margin-right: 1em;
}

#userActions * {
  width: 2em;
  height: 2em;
  margin-bottom: 0.3em;
  padding: 2px;
  border-bottom: 2px solid grey;
  margin: auto 0;
}

#userActions *:hover {
  border-color:  grey;
  color: grey; 
}

#userinfo * {
  margin: auto 0;
}
#userinfo{
  text-align: left;
  margin-right: 0.5em;
  padding-right: 0.5em;
  border-right: 2px solid grey;
  display: flex;
  flex: 1;
}
#userinfo p{
  margin: 0;
  color:  rgba(0, 0, 0, 0.856)  ;
}
#userinfo b{
  color: black;
}

.segment{
  height: 100%;
}
</style>