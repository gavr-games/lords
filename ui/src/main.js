import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import {WSClient}  from './lib/ws/wsclient'
import '@/components/ui/loader'

Vue.config.productionTip = false
Vue.prototype.$WSClient = new WSClient()

new Vue({
  router,
  store,
  render: function (h) { return h(App) }
}).$mount('#app')
