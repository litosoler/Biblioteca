<template>
	<v-container grid-list-md text-xs-center>
   <v-layout row wrap>
     <v-flex xs12>
       <h1>Prestamos</h1>
       <table class="table historial">
        <tbody>
         <tr>
          <th scope="row">Libro</th>
          <th scope="row">Fecha Inicio</th>
          <th scope="row">Fecha Fin</th>
        </tr>
        <tr v-for="libro in historial">
          <td>{{libro.libro}}</td>
          <td>{{libro.fechaI}}</td>
          <td>{{libro.fechaF}}</td>
        </tr>
      </tbody>
    </table>
  </v-flex>
</v-layout> 
</v-container>
</template>

<script>
export default {
	data(){
		return{
      historial: []
    }
  },
  methods:{
    async obtenerCompras(){
      var params = new URLSearchParams();
      params.append('idPersona', this.$store.state.cliente.idPersona);
      let respuesta = await Axios.post('/api/getters.php?opcion=12', params).then( resp =>  resp.data).catch(err => {console.log(err)});
      this.historial = respuesta
    }
  }
}
</script>

<style >
.historial{
  margin-top: 60px;
}

.historial th, .historial td{
  padding-top: 20px !important;
}
</style>