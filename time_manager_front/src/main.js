import './assets/main.css'
import { createApp } from 'vue'
import App from './App.vue'
import { library } from '@fortawesome/fontawesome-svg-core'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import { faTrash, faPenToSquare, faMagnifyingGlass, faChartLine, faUsers, faUser, faUserTie, faSignOutAlt } from '@fortawesome/free-solid-svg-icons';
import router from './routers';
import { checkAuth } from '@/services/authService'


const initApp = async () => {
library.add(faTrash, faPenToSquare, faMagnifyingGlass, faChartLine, faUsers, faUser, faUserTie, faSignOutAlt);

const app = createApp(App);
await checkAuth()
app.component('font-awesome-icon', FontAwesomeIcon);
app.use(router);
app.mount('#app');
}
initApp()

