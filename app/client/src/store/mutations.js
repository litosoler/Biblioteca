export default {
    init(state, libros) {
        state.libros = libros;
    },
    guardarSeleccion(state, idLibroSelec){
    	state.libroSelec = state.libros.find(libro => libro.idLibro == idLibroSelec );
    }
};