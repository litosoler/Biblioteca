<template>
	<div class="container principal">
		<section class="row " >
			<div class="col-md-5 img-col">  
				<img src="@/assets/Logo.jpeg" class="img-fluid logo" alt="Bienvenido">
			</div>
			<div class="mensaje col-md-7" >
				“La verdadera universidad en nuestros días consiste en una colección de libros”. Thomas Carlyle
				<br>
				<br>
				“He buscado por todas partes el sosiego y no lo he encontrado sino en un rincón apartado, con un libro en las manos”. Tomás Kempis

			</div>
		</section>
		<section class="row search-row">
			<div class="offset-3 col-6">
				<div class="input-group mb-3">
					<input type="text" class="form-control" placeholder="Encuentra tu libro" aria-label="Recipient's username" aria-describedby="basic-addon2" autofocus @keyup="buscar">
					<div class="input-group-append green">
						<button class="btn btn-default white" type="button" @click="buscar2">Buscar</button>
					</div>
				</div>	
			</div>
			

		</section>

	</div>
</template>

<script>
	export default{
		mounted(){
			this.$store.state.busquedaString = ""
		},
		methods:{
			buscar(event){
				if(event.target.value.length > 2){
					this.$store.state.busquedaString = event.target.value
					this.$store.dispatch("realizarBusqueda",{cadena : this.$store.state.busquedaString})
					this.$router.push("/resultados")
				}
			},
			buscar2(){
					this.$store.dispatch("realizarBusqueda",{cadena : this.$store.state.busquedaString})
					this.$router.push("/resultados")
			}
		}
	}
</script>

<style >
.principal{
	margin-top: 30px;
}

.img-col{
	border-right: 1px solid green;
}
.search-row{
	margin-top: 40px;
}

</style>