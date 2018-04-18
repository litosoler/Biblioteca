<template>
	<v-app>
		<v-navigation-drawer  fixed
		v-model="drawer"
		app>
		<v-toolbar >
			<v-list >
				<v-list-tile id="inicioSesion">
					<v-list-tile-title class="title">
						<router-link to="/" class="link-blue">Cerrar Sesion</router-link>
					</v-list-tile-title>
				</v-list-tile>
			</v-list>
		</v-toolbar>
	</br>
	<v-list dense class="pt-0">
		<router-link :to="item.link"  v-for="item in items" class="link-blue">
			<v-list-tile :key="item.title" @click="">
				<v-list-tile-action>
					<v-icon>{{ item.icon }}</v-icon>
				</v-list-tile-action>
				<v-list-tile-content>
					<v-list-tile-title>{{ item.title }}</v-list-tile-title>
				</v-list-tile-content>
			</v-list-tile>
		</router-link>
	</v-list>
</v-navigation-drawer>
<v-toolbar color="indigo" dark fixed app>
	<v-toolbar-side-icon @click.stop="drawer = !drawer"></v-toolbar-side-icon>
	<v-toolbar-title><router-link to="/empleados" class="link">Libreria</router-link></v-toolbar-title>
</v-toolbar>
<v-content>
	<v-container fluid>
		<router-view></router-view>
	</v-container>
</v-content>
</v-app>
</template>

<script>

export default{
	props:{
		source: String
	},
	data () {
		return {
			drawer: null,
			items: [
			{ title:'Home', icon: 'dashboard', link:"/empleados/" },
			{ title:'Facturar', icon: 'dashboard', link:"/empleados/facturar" },
			{ title:'Enviar Libros', icon:'assignment_ind', link:"/empleados/enviarLibros" },
			{ title:'Recibir Libros', icon:'assignment_ind', link:"/empleados/recibirLibros" },
			],
			right: null
		}
	}
}
</script>
<style>
.principal{
	margin-top: 30px;
}

.img-col{
	border-right: 1px solid green;
}
.search-row{
	margin-top: 40px;
}
.toolbar{
	background-color: #3378C5;
}
.link{
	color:white;
}
.link:hover{
	color:white;
	text-decoration: none;
}
.link-blue{
	color:#3F51B5;
}
.link-blue:hover{
	color:#3F51B5;
	text-decoration: none;
}
#inicioSesion{
	margin-left: 51px;
}
</style>
