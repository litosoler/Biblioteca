<template>
  <div class="container">
    <div class="row">
      <div class="offset-md-2 col-sm-8">
        <v-card class="elevation-12" >
              <v-toolbar dark color="primary">
                <v-toolbar-title>Login form</v-toolbar-title>
                <v-spacer></v-spacer>
              </v-toolbar>
              <v-card ref="form">
              <v-card-text ref="form">
                
                  <v-text-field v-model="user" required  ref="user" :rules="[() => !!user || 'This field is required']"  prepend-icon="person" name="login" label="Login" type="text"  ></v-text-field>
                  <v-text-field required v-model="pwd" prepend-icon="lock" name="password" label="Password" id="password" type="password" :rules="[() => !!pwd || 'This field is required']" ref="pwd"></v-text-field>
           
              </v-card-text>
               </v-card>
              <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn color="primary" @click="verificarUsuario">Login</v-btn>
              </v-card-actions>
           
            </v-card>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    mounted(){
      this.verificarSesion();
    },
    data: () => ({
      drawer: null,
      user: "",
      pwd : ""
    }),
    props: {
      source: String
    },
    computed: {
      form () {
        return {
          user: this.user,
          pwd: this.pwd
        }
      }
    },
    methods:{
      async verificarUsuario(){
        Object.keys(this.form).forEach(f => {
          this.$refs[f].validate(true)
        })

        if(this.user && this.pwd){
          var params = new URLSearchParams();
          params.append('correo', this.user);
          params.append('password', this.pwd);
          let respuesta = await Axios.post('/api/getters.php?opcion=1', params).then( resp =>  resp.data).catch(err => {console.log(err)});
          console.log(respuesta)
          if(respuesta.tipoUsuario == 0){
            alert("Usuario/Contraseña Incorrecta");
          }else if(respuesta.tipoUsuario == 1){
            this.$store.dispatch('guardarUsuario', {tipoUsuario : respuesta.tipoUsuario, codigoUsuario: respuesta.codigoUsuario});
            this.$router.push("/empleados")
          }else if(respuesta.tipoUsuario == 2){
            this.$store.dispatch('guardarUsuario', {tipoUsuario : respuesta.tipoUsuario, codigoUsuario: respuesta.codigoUsuario});
            this.$router.push("/clientes")
          }
        }
      },
      async verificarSesion(){

          let respuesta = await Axios.get('/api/getters.php?opcion=4').then( resp =>  resp.data).catch(err => {console.log(err)});

                    console.log(respuesta)

         if(respuesta.tipoUsuario == 1){
            this.$store.dispatch('guardarUsuario', {tipoUsuario : respuesta.tipoUsuario, codigoUsuario: respuesta.codigoUsuario});
            this.$router.push("/empleados")
          }else if(respuesta.tipoUsuario == 2){
            this.$store.dispatch('guardarUsuario', {tipoUsuario : respuesta.tipoUsuario, codigoUsuario: respuesta.codigoUsuario});
            this.$router.push("/clientes")

          }
      },
    }
  }
</script>