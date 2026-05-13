import Vue from 'vue'
import axios from "axios";
import App from './App.vue'
import router from './router'
import store from './store'
import plugins from './plugins'
import Element from "element-ui";
import locale from "element-ui/lib/locale/lang/zh-CN";
import { setupSessionExpiredHandler } from "@/utils/sessionExpired";
import 'swiper/dist/css/swiper.min.css'
import 'swiper/dist/js/swiper.min'
/*  引入element 样式 */
import 'element-ui/lib/theme-chalk/index.css'
Vue.config.productionTip = false
Vue.prototype.$axios = axios;
setupSessionExpiredHandler(router, store);
Vue.use(plugins).use(Element, {
  locale,
});

import JsonExcel from 'vue-json-excel'
import { trackPageView } from '@/utils/track'
Vue.component('downloadExcel', JsonExcel)

router.afterEach((to) => {
  trackPageView(to.path)
})

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')
