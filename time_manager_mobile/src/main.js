import './assets/main.css';
import { createApp } from 'vue';
import App from './App.vue';
import { library } from '@fortawesome/fontawesome-svg-core';
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';
import { faMagnifyingGlass, faChartLine, faUsers, faUser, faUserTie } from '@fortawesome/free-solid-svg-icons';
import { checkAuth } from './services/authService';
import router from './routers';

const initApp = async () => {
    library.add(faMagnifyingGlass, faChartLine, faUsers, faUser, faUserTie);

    const app = createApp(App);
    await checkAuth();
    app.component('font-awesome-icon', FontAwesomeIcon);
    app.use(router);
    app.mount('#app');
};

initApp();