<template>
	<section>
		<div class="container">
			<div class="row">
				<div class="col-sm-4">
					<label class=" control-label">Buscar:</label>
					<input type="text" class="form-control input" v-model="porBuscar">
				</div>
				<div class="col-sm-3">
					<label class=" control-label">Ordenar:</label>
					<input type="text" class="form-control input ">
				</div>
				<div class="col-sm-3">
					<label class=" control-label">Filtro:</label>
					<input type="text" class="form-control input ">
				</div>
				<div>
					<button id="buscar" class="col-sm-2 btn yellow" @click="buscar">Buscar</button>
				</div>
			</div>
		</div>
		<div class="container">
			<div class="row">
				<div class="col-sm-6" v-for="libro in libros">
					<div class="resultado-frame " >
						<label class="titulo">{{libro.nombre}}</label>
						<div class="informacion">
							<div class="row">
								<div class="col-md-6">
									<li>Biblioteca: {{libro.biblioteca}}</li>
								</div>
								<div class="col-md-6">
									<li>Autores: {{libro.autores}}</li>
								</div>
								<div class="col-md-6">
									<li>Precio: {{libro.precio}}</li>
								</div>
								<div class="col-md-6">
									<li>N° Páginas: {{libro.noPaginas}}</li>										
								</div>
							</div>
						</div>
						<button  @click="verDetalles(libro.idLibro)" class="btn blue detalles">Ver Detalles</button>
					</div>
				</div>
			</div>
		</div>

		<v-layout row justify-center>
			<v-dialog v-model="dialog" fullscreen transition="dialog-bottom-transition" :overlay="false">
				<v-card>
					<v-toolbar dark color="primary">
						<v-btn icon @click.native="dialog = false" dark>
							<v-icon>close</v-icon>
						</v-btn>

					</v-toolbar>
					<div class="container">
						<div class="row">
							<div>
								<h1> {{selec.nombre}} </h1>
								<div>
									<h3> {{selec.descrip}} </h3>
								</div>
							</div>				
						</div>
						<div class="row libro-detalles">
							<div class="col-md-6 " >
								<ul>
									<li><label>Autor:</label>{{selec.autor}}</li>
									<li><label>Biblioteca:</label>{{selec.biblioteca}}</li>
									<li><label>Precio:</label>{{selec.precio}}</li>
								</ul>
							</div>
							<div class="col-md-6">
								<ul>
									<li><label>Edicion:</label>{{selec.edicion}}</li>
									<li><label>ISBN:</label>{{selec.isbn}}</li>
									<li><label>Editorial:</label>{{selec.editorial}}</li>
								</ul>
							</div>
						</div>
					</div>
				</v-card>
			</v-dialog>
		</v-layout>
	</section>

</template>

<script>
export default {
	 data () {
      return {
      	//se usan con el modal
        dialog: false,
        notifications: false,
        sound: true,
        widgets: false,
        //propias
        selec: {},
        porBuscar: "",
        //1:ASC, 2:Desc
        ordenar: 1,
        //1:autores, 2:bibliotecas, 3,libros
        filtro: 3,

      }
    },
	computed: {
		libros(){
			return 	this.$store.getters.libros;
		}
	},
	methods:{
		verDetalles(idLibro){
			this.$store.commit('guardarSeleccion', idLibro);
			this.selec = this.$store.getters.seleccionado;
			this.dialog = true;
		},
		buscar(){
			alert("buscar:" + this.porBuscar);
		}
	}
}
</script>
<style >

.titulo{
	font-size: xx-large;
	font-family: aria;
	font-weight: bold;
}
.resultado-frame{
	border: 1px solid green;
	padding: 20px;
	margin-top: 15px;
	position: relative;
	background-color: white;
}
.informacion{
	padding: 0px 15px;
	margin: 25px 0px 75px 0px ;
}
.detalles{
	position: absolute;
	right: 9px;
	bottom: 10px
}
.input{
	border: solid 1px;
}
.blue{
	color: white;
}
#buscar{
	margin-top: 20px;
}
.libro-detalles{
	margin-top: 60px;
}
.libro-detalles label{
	font-size: 15px;
  font-weight: bolder;
	margin-right: 15px;
}
</style>