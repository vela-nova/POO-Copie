import { ref, markRaw } from 'vue';
import WorkingTimes from '../components/WorkingTimes.vue';
import User from '../components/User.vue';
import ChartManager from '../components/ChartManager.vue';
import ClockManager from '../components/ClockManager.vue';
import DashBoard from '../components/Dashboard.vue';

export const components = {
  WorkingTimes: markRaw(WorkingTimes),
  User: markRaw(User),
  ChartManager: markRaw(ChartManager),
  ClockManager: markRaw(ClockManager),
  DashBoard: markRaw(DashBoard)
};

export const currentComponent = ref('DashBoard');

export const switchComponent = (component) => {
  currentComponent.value = component;
};