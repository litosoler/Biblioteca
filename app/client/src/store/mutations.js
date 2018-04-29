export default {

    initCiudades(state, ciudades) {
        state.ciudades = ciudades;
    },
    initGeneros(state, generos) {
        state.generos = generos;
    },
    guardarSeleccion(state, idLibroSelec){
    	state.libroSelec = state.libros.find(libro => libro.idLibro == idLibroSelec );
    },
    setCliente(state, cliente){
        state.cliente = cliente;
    },
    setEmpleado(state, empleado){
        state.empleado = empleado;
    },
    setResultadosBusqueda(state, libros){
        state.libros = libros;
    },
};