<template>
        
     <v-jumbotron

    :gradient="gradient"
    dark
  >
    <v-container fill-height>
      <v-layout align-center>
        <v-flex text-xs-center>
          <h1 class="display-3">
          	¡Bienvenido!

          </h1>
        </v-flex>
      </v-layout>
    </v-container>
  </v-jumbotron>
       
</template>

<script>
  export default {
    data: () => ({
      gradient: 'to top right, rgba(63,81,181, .7), rgba(25,32,72, .7)'
    })
  }
</script>