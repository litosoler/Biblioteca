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
		<v-footer color="indigo" app>
      <span class="white--text">&copy; 2017</span>
    </v-footer>
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
