<template>
  <div>
    {{ libros }}
  </div>
</template>

<script>
export default {
  name: 'HelloWorld',
  computed: {
  	libros() {
      return this.$store.getters.libros;
	}
	}
  
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>

</style>
