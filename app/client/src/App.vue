<template>
	<v-app>
		<v-navigation-drawer  fixed
      v-model="drawer"
      app></v-navigation-drawer>
		<v-toolbar color="indigo" dark fixed app>
			 <v-toolbar-side-icon @click.stop="drawer = !drawer"></v-toolbar-side-icon>
      <v-toolbar-title>Libreria</v-toolbar-title>
		</v-toolbar>
		<v-content>
			<v-container fluid>
				<router-view></router-view>
			</v-container>
		</v-content>
	</v-app>
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
	},
	

}
</script>
