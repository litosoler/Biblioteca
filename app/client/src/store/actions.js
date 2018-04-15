export default {
    init: async function({ commit }) {
    	let libros =  await Axios.get('/api/prueba.php').then( resp =>  resp.data).catch(err => {console.log(err)});
    	console.log(libros);
    	// commit('init', libros);
    },
    
}
