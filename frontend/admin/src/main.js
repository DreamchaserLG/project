import Vue from 'vue';
import axios from "axios";
import App from './App.vue'
import './registerServiceWorker'
import plugins from './plugins'
import router from './router'
import store from './store'
import echarts from './assets/js/echarts.min.js'
import { setupSessionExpiredHandler } from "@/utils/sessionExpired";

Vue.config.productionTip = false;
Vue.prototype.$axios = axios;
setupSessionExpiredHandler(router, store);

let apiBaseUrl = process.env.VUE_APP_API_BASE_URL || "/";
if (!apiBaseUrl.endsWith("/")) {
    apiBaseUrl += "/";
}

Vue.use(plugins, {
    host: apiBaseUrl,
});

import JsonExcel from 'vue-json-excel'
Vue.component('downloadExcel', JsonExcel)

new Vue({
  router,
  store,
  echarts,
  render: h => h(App)
}).$mount('#app')
