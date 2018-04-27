<template>
	<router-view></router-view>
</template>

<script>
export default {
	props:{
		source: String
	},
	data () {
		return {
			drawer: null,
		}
	},
	name: 'App',
	mounted(){
		this.$store.dispatch('init');
		this.verificarSesion();
	},
	methods:{
		async verificarSesion(){

          let respuesta = await Axios.get('/api/getters.php?opcion=4').then( resp =>  resp.data).catch(err => {console.log(err)});

                    console.log(respuesta)

         if(respuesta.tipoUsuario == 1){
            this.$store.dispatch('guardarUsuario', {tipoUsuario : respuesta.tipoUsuario, codigoUsuario: respuesta.codigoUsuario});
            this.$router.push("/empleados")
          }else if(respuesta.tipoUsuario == 2){
            this.$store.dispatch('guardarUsuario', {tipoUsuario : respuesta.tipoUsuario, codigoUsuario: respuesta.codigoUsuario});
            this.$router.push("/clientes")

          }
      },
	}
	

}
</script>
