<template>
	<v-container grid-list-md text-xs-center>
   <v-layout row wrap>
     <v-flex xs12>
       <h1>Compras</h1>
       <table class="table historial">
        <tbody>
         <tr>
          <th scope="row">Fecha</th>
          <th scope="row">Libro</th>
          <th scope="row">Precio</th>
        </tr>
        <tr v-for="libro in historial">
          <td>{{libro.fecha}}</td>
          <td>{{libro.libro}}</td>
          <td>{{libro.precio}}</td>
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
      {fecha: "2018-12-12", libro:'libro1', precio:'gratis'},
      {fecha: "2018-12-12", libro:'libro2', precio:'gratis'},
      {fecha: "2018-12-12", libro:'libro3', precio:'gratis'},
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