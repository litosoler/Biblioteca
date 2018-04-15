import Vue from 'vue'
import Router from 'vue-router'
import index from '@/pages/index'
import inicioSesion from '@/pages/inicioSesion'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'index',
      component: index
    },
    {
      path: '/inicioSesion',
      name: 'inicioSesion',
      component: inicioSesion
    }
  ]
})
