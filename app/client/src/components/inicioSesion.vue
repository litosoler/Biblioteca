<template>
  <div class="container">
    <div class="row">
      <div class="offset-md-2 col-sm-8">
        <v-card class="elevation-12">
              <v-toolbar dark color="primary">
                <v-toolbar-title>Login form</v-toolbar-title>
                <v-spacer></v-spacer>
              </v-toolbar>
              <v-card-text>
                <v-form>
                  <v-text-field v-model="user" prepend-icon="person" name="login" label="Login" type="text"></v-text-field>
                  <v-text-field v-model="pwd" prepend-icon="lock" name="password" label="Password" id="password" type="password"></v-text-field>
                </v-form>
              </v-card-text>
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
    data: () => ({
      drawer: null,
      user: "",
      pwd : ""
    }),
    props: {
      source: String
    },
    methods:{
      verificarUsuario(){
        alert('user:' + this.user + 'pwd:' + this.pwd);
      },
    }
  }
</script>