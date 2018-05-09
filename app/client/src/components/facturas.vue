<template>
	<div class="container">
		<div class="row">
			<div class="col-3">
				<div class="form-group" >
					<label >Cliente:</label>
					<select class="form-control" v-model="idCliente">
						<option value="">Seleccione....</option>
						<option v-for="item in clientes" :value="item.idPersona">{{item.identidad}}</option>
					</select>
				</div>
			</div>
			<div class="col-3">
				<div class="form-group" >
					<label >Forma Pago:</label>
					<select class="form-control" required="true" v-model="idFormaPago">
						<option value="">Seleccione....</option>
						<option v-for="item in formasPago" :value="item.idFormaPago">{{item.descripcion}}</option>
					</select>
				</div>
			</div>
				<div class="col-3">
					<div class="form-group">
						<label for="">Empleado:</label>
						<input type="text" class="form-control" disabled="" v-model="nombreEmpleado" >
					</div>
				</div>
			
			<div class="col-2">
				<div class="form-group" >
					<label >Fecha:</label>
					<input type="date" class="form-control" v-model="fecha" disabled="" style="width:unset">
				</div>
			</div>
		</div>
			<form>
		<div class="row">
			<button class="btn blue" @click="nuevoDetalle">añadir</button>
			<button type="submit" class="btn green" @click="guardarFactura">guardar</button>
			<table class="table historial col-12" >
				<tbody>
					<tr class="row">
						<th scope="row" class="col-6">Libro</th>
						<th scope="row" class="col-2">Precio</th>
					</tr>
					<tr v-for="(detalle, index) in detalles" class="row">
						<td class="col-6">
							<select class="form-control" v-model="detalle.idLibro" @change="calcularPrecio(detalle)" >
								<option value="">Seleccionar</option>	
								<option v-for="libro in libros" :value="libro.id">{{libro.nombreLibro.toLowerCase()}}</option>	
							</select>
						</td>
						<td class="col-2">
							{{parseInt(detalle.precioVenta)}}
						</td>
					</tr>
				</tbody>
			</table>
		</div>
				</form>
		<hr>
		<div class="row">
			<p class="col-2">Sub-Total: {{subtotal}}</p>		
			<p class="col-2">ISV: {{isv}}</p>		
			<p class="col-2">Total: {{total}}</p>		
		</div>
		<div class="row">
			<div class="col-12">
				<label for="comentario">Comentarios:</label>
				<textarea id="comentario" cols="2" rows="2" class="form-control" v-model="comentario"></textarea>
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
	created(){
		let fecha = new Date();		let dia = fecha.getDay();
		let mes = fecha.getMonth() + 1;
		let ano = fecha.getFullYear();
		if (dia < 10){ dia = "0"+dia};
		if (mes < 10){ mes = "0"+mes};

		this.fecha = ano+"-"+mes+"-"+dia;
		this.empleado = this.$store.state.empleado

		this.obtenerFormasPago();
		this.obtenerClientes();
		this.obtenerLibros();
	},
	mounted(){
		this.nombreEmpleado = this.empleado.pNombre + ' ' + this.empleado.pApellido
	},
	data(){
		return{
			detalles:[
				{precioVenta: '' ,idLibro: ''},
			],
			subtotal: "0",
			fecha: undefined,
			formasPago: [],
			empleado : {},
			clientes:[],
			libros:[],
			nombreEmpleado: "",
			idCliente: "",
			idFormaPago:"",
			comentario:""
		}
	},
	watch:{
		detalles:{
			handler(val){
				this.subtotal = 0;

				for(let i = 0; i < this.detalles.length; i++){
					if(this.detalles[i].precioVenta != "")
					this.subtotal += parseInt(this.detalles[i].precioVenta )
				}
			},
			deep: true
		}
	},
	computed:{
		isv: function(){
			return this.subtotal * 0.15
		},
		total: function(){
		 return	this.isv + this.subtotal
		}	
	},
	methods:{
		nuevoDetalle(){
			let detalle = {idLibro:"", precioVenta:"", id:""};
			this.detalles.push(detalle);
		},
		async obtenerFormasPago(){
			this.formasPago =  await Axios.get('/api/getters.php?opcion=8').then( resp =>  resp.data).catch(err => {console.log(err)});
	
		},	
		async obtenerClientes(){
			this.clientes =  await Axios.get('/api/getters.php?opcion=9').then( resp =>  resp.data).catch(err => {console.log(err)});
	
		},
		async guardarFactura(){
			let factura = {}

				factura.detalles = this.detalles.map(function(detalle){ return detalle.idLibro  });
				factura.empleado = this.empleado.idPersona
				factura.cliente = this.idCliente
				factura.formaPago = this.idFormaPago
				factura.comentario = this.comentario
				factura.idImpuesto = 1

				if(factura.detalles.length > 0 && factura.formaPago){
				
			    var params = new URLSearchParams();
	        params.append('detalles', factura.detalles);
	        params.append('idEmpleado', factura.empleado);
	        params.append('idCliente', factura.cliente);
	        params.append('idFormaPago', factura.formaPago);
	        params.append('comentario', factura.comentario);
	        params.append('idImpuesto', factura.idImpuesto);


	      	let respuesta = await Axios.post('/api/setters.php?opcion=3', params).then( resp =>  resp.data).catch(err => {console.log(err)});

	      	alert("factura ingresada!!");
	      	this.obtenerLibros();

	      	this.detalles = [
						{precioVenta: '' ,idLibro: ''},
					]
					this.subtotal = "0"
					this.idCliente = ""
					this.idFormaPago= ""
					this.comentario = ""


    		}else{
    			alert("faltan datos importantes")
    		}
		},
		async obtenerLibros(){
			this.libros =  await Axios.get('/api/getters.php?opcion=10').then( resp =>  resp.data).catch(err => {console.log(err)});

		},
		calcularPrecio(detalle){
			let seleccion = this.libros.find( function(libro){
				return libro.id == detalle.idLibro
			}, detalle);

			if (seleccion.idEstante == 45){
				detalle.precioVenta = seleccion.precioVenta
			}else{
				detalle.precioVenta = 0
			}
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