<template>
	<router-view></router-view>
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
