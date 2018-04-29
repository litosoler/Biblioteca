export default {
    init: async function({ commit }) {
    	let ciudades =  await Axios.get('/api/getters.php?opcion=7').then( resp =>  resp.data).catch(err => {console.log(err)});
    	let generos =  await Axios.get('/api/getters.php?opcion=3').then( resp =>  resp.data).catch(err => {console.log(err)});
    	commit('initCiudades', ciudades);
    	commit('initGeneros', generos);
    },
    guardarUsuario: async function({ commit }, info){
    	let tipoUsuario = info.tipoUsuario;
    	let idUsuario = info.codigoUsuario
    	let respuesta = undefined;
    	if (tipoUsuario == 1) {
  			var params = new URLSearchParams();
            params.append('idPersona', idUsuario);
            respuesta = await Axios.post('/api/getters.php?opcion=5', params).then( resp =>  resp.data).catch(err => {console.log(err)});
            commit('setEmpleado', respuesta)
    	}else if(tipoUsuario == 2){
  			var params = new URLSearchParams();
            params.append('idPersona', idUsuario);
            respuesta = await Axios.post('/api/getters.php?opcion=2', params).then( resp =>  resp.data).catch(err => {console.log(err)});
    		console.log(respuesta)
            commit('setCliente', respuesta);
    	}
    },
    realizarBusqueda: async function({commit}, info){
        var params = new URLSearchParams();
        params.append('cadena', info.cadena);
        let respuesta = await Axios.post('/api/getters.php?opcion=13', params).then( resp =>  resp.data).catch(err => {console.log(err)});
        commit('setResultadosBusqueda', respuesta)
    }
    
}
