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
      historial: [
      {fechaI: "2018-12-12", fechaF: "2018-12-15",  libro:'libro1'},
      {fechaI: "2018-12-12", fechaF: "2018-12-15",  libro:'libro2'},
      {fechaI: "2018-12-12", fechaF: "2018-12-15",  libro:'libro3'},
      ]
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