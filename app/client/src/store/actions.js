export default {
    init: async function({ commit }) {
    	let paises =  await Axios.get('/api/getters.php?opcion=1').then( resp =>  resp.data).catch(err => {console.log(err)});
    	let ciudades =  await Axios.get('/api/getters.php?opcion=2').then( resp =>  resp.data).catch(err => {console.log(err)});
    	let generos =  await Axios.get('/api/getters.php?opcion=3').then( resp =>  resp.data).catch(err => {console.log(err)});
    	commit('initPaises', paises);
    	commit('initCiudades', ciudades);
    	commit('initGeneros', generos);
    },
    
}
