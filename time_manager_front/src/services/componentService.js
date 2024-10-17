import { ref, markRaw } from 'vue';
import WorkingTimes from '../components/WorkingTimes.vue';
import User from '../components/User.vue';
import ChartManager from '../components/ChartManager.vue';
import ClockManager from '../components/ClockManager.vue';

export const components = {
  WorkingTimes: markRaw(WorkingTimes),
  User: markRaw(User),
  ChartManager: markRaw(ChartManager),
  ClockManager: markRaw(ClockManager)
};

export const currentComponent = ref('WorkingTimes');

export const switchComponent = (component) => {
  currentComponent.value = component;
};