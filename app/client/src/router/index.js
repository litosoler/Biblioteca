import Vue from 'vue'
import Router from 'vue-router'
import HelloWorld from '@/components/HelloWorld'
import inicioSesion from '@/pages/inicioSesion'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'HelloWorld',
      component: HelloWorld
    },
    {
      path: '/inicioSesion',
      name: 'inicioSesion',
      component: inicioSesion
    }
  ]
})
