<template>
  <router-view/>
</template>

<script>
export default {
  data () {
    return {
    }
  },
  name: 'App',
  mounted(){
    this.$store.dispatch('init');
  }
}
</script>
