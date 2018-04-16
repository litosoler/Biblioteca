<template>
	<v-container grid-list-md text-xs-center>
   <v-layout row wrap>
     <v-flex xs12>
       <h1>Puntos</h1>
       <table class="table historial">
        <tbody>
         <tr>
          <th scope="row">Fecha Movimiento</th>
          <th scope="row">Cantidad</th>
          <th scope="row">Tipo Movimiento</th>
        </tr>
        <tr v-for="punto in historial">
          <td>{{punto.fecha}}</td>
          <td>{{punto.cantidad}}</td>
          <td>{{punto.tipo}}</td>
        </tr>
        <tr>
          <td>Total</td>
          <td>{{total}}</td>
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
      {fecha: "2018-12-12", cantidad:100, tipo:"credito"},
      {fecha: "2018-12-12", cantidad:100, tipo:"credito"},
      {fecha: "2018-12-12", cantidad:100, tipo:"credito"},
      ]
    }
  },
  computed:{
    total(){
      let total = 0;
      for (var i = 0; i < this.historial.length; i++) {
        total += this.historial[i].cantidad;
      } 
     return total;
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