export default {
    initPaises(state, paises) {
        state.paises = paises;
    },
    initCiudades(state, ciudades) {
        state.ciudades = ciudades;
    },
    initGeneros(state, generos) {
        state.generos = generos;
    },
    guardarSeleccion(state, idLibroSelec){
    	state.libroSelec = state.libros.find(libro => libro.idLibro == idLibroSelec );
    }
};