import Vue from 'vue';
import Vuex from 'vuex';

import actions from './actions';
import mutations from './mutations';
import getters from './getters';

Vue.use(Vuex);

export const store = new Vuex.Store({
	state: {
		libros: [
		{idLibro: 1, nombre: "Titilo", noPaginas:"xxx", autor: "...", precio: "xxx", biblioteca: "Nombre ", descrip:"What is Lorem Ipsum? Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. ", isbn: ".....", edicion: ".....", editorial: "....." },
		{idLibro: 2, nombre: "Titulo", noPaginas:"xxx", autor: "...", precio: "xxx", biblioteca: "nombre biblioteca", descrip:"What is Lorem Ipsum? Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. ", isbn: ".....", edicion: ".....", editorial: "....." },
		{idLibro: 3, nombre: "Titulo", noPaginas:"xxx", autor: "...", precio: "xxx", biblioteca: "nombre biblioteca", descrip:"What is Lorem Ipsum? Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. ", isbn: ".....", edicion: ".....", editorial: "....." },
		{idLibro: 3, nombre: "Titulo", noPaginas:"xxx", autor: "...", precio: "xxx", biblioteca: "nombre biblioteca", descrip:"What is Lorem Ipsum? Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. ", isbn: ".....", edicion: ".....", editorial: "....." }
		],
		libroSelec: {},

	},
	getters,
	mutations,
	actions
});