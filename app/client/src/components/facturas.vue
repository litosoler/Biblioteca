<template>
	<div class="container">
		<div class="row">
			<div class="col-3">
				<div class="form-group" >
					<label >Cliente:</label>
					<select class="form-control">
						<option value="">....</option>
					</select>
				</div>
			</div>
			<div class="col-2">
				<div class="form-group" >
					<label >Forma Pago:</label>
					<select class="form-control">
						<option value="">....</option>
					</select>
				</div>
			</div>
				<div class="col-3">
					<div class="form-group">
						<label for="pNombre">Empleado:</label>
						<input type="text" class="form-control" disabled="" value=".............">
					</div>
				</div>
			
			<div class="col-3">
				<div class="form-group" >
					<label >Fecha:</label>
					<input type="date" class="form-control" v-model="fecha" disabled="">
				</div>
			</div>
		</div>
		<div class="row">
			
			<button class="btn blue" @click="nuevoDetalle">añadir</button>
			<table class="table historial col-12" >
				<tbody>
					<tr class="row">
						<th scope="row" class="col-6">Libro</th>
						<th scope="row" class="col-2">Cantidad</th>
						<th scope="row" class="col-2">Precio</th>
						<th scope="row" class="col-2">Sub-Total</th>
					</tr>
					<tr v-for="detalle in factura.detalles" class="row">
						<td class="col-6">
							<select class="form-control" v-model="detalle.idLibro">
								<option value="">....</option>	
							</select>
						</td>
						<td class="col-2">
							<select class="form-control" v-model="detalle.cantidad">
								<option value="">....</option>	
							</select>
						</td>
						<td class="col-2">
							...
						</td>
						<td class="col-2">
							...
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<hr>
		<div class="row">
			<p class="col-2">Sub-Total: {{total}}</p>		
			<p class="col-2">ISV: {{total}}</p>		
			<p class="col-2">Total: {{total}}</p>		
		</div>
		<div class="row">
			<div class="col-12">
				<label for="comentario">Comentarios:</label>
				<textarea id="comentario" cols="2" rows="2" class="form-control"></textarea>
			</div>
		</div>
		<div class="row">
			<div class="container">
				What is Lorem Ipsum?
				Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s 		
			</div>
		</div>
	</div>
</template>

<script>
export default{
	mounted(){
		let fecha = new Date();
		let dia = fecha.getDay();
		let mes = fecha.getMonth() + 1;
		let ano = fecha.getFullYear();
		if (dia < 10){ dia = "0"+dia}
			if (mes < 10){ mes = "0"+mes}
				console.log(dia)
			this.fecha = `${ano}-${mes}-${dia}`;

		},
		data(){
			return{
				factura:{
					detalles:[
					{idLibro:"", cantidad:""},
					]	
				},
				total: 150,
				fecha: undefined
			}
		},
		methods:{
			nuevoDetalle(){
				let detalle = {idLibro:"", cantidad:""};
				this.factura.detalles.push(detalle);
			}
		}
		
		
	}
	</script>

	<style >
	.historial{
		margin-top: 15px;
		margin-bottom: 20px;

	}


	.historial th{
		padding-top: 20px !important;
	}
	.historial td{
		padding-top: 6px !important;
	}

	</style>