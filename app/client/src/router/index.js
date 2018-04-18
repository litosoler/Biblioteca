import Vue from 'vue'
import Router from 'vue-router'

import index from '@/pages/index'
import empleados from '@/pages/empleados'
import clientes from '@/pages/clientes'

import inicioSesion from '@/components/inicioSesion'
import search from '@/components/search'
import results from '@/components/results'
import registrarse from '@/components/registroCliente'

import historialCompras from '@/components/historialCompras'
import historialPrestamos from '@/components/historialPrestamos'
import historialPuntos from '@/components/historialPuntos'
import configuracion from '@/components/configuracion'
import bienvenida from '@/components/bienvenida'

import facturar from '@/components/facturas'
import enviarLibros from '@/components/enviarLibros'
import recibirLibros from '@/components/recibirLibros'




Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'index',
      component: index,
      children:[
        {
          path: '/',
          component:search 
        },
        {
          path: '/inicioSesion',
          component: inicioSesion
        },
        {
          path: '/resultados',
          component: results
        },
        {
          path: '/registrarse',
          component: registrarse
        }

      ]
    },
    {
      path: '/empleados',
      name: 'empleados',
      component: empleados,
      children:[
        {
          path:'/empleados',
          component: bienvenida
        },
        {
          path: '/empleados/facturar',
          component:facturar 
        },
        {
          path: '/empleados/enviarLibros',
          component: enviarLibros
        },
        {
          path: '/empleados/recibirLibros',
          component: recibirLibros
        }
      ]
    },
    {
      path: '/clientes',
      name: 'clientes',
      component: clientes,
      children:[
        {
          path:'/clientes',
          component: bienvenida
        },
        {
          path: '/clientes/hitorialPuntos',
          component:historialPuntos 
        },
        {
          path: '/clientes/historialPrestamos',
          component: historialPrestamos
        },
        {
          path: '/clientes/hitorialCompras',
          component: historialCompras
        },
        {
          path: '/clientes/configuracion',
          component: configuracion
        },
      ]
    }
  ]
})
