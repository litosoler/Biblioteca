<template>
	<form class="container cuerpo">
	<div class="form-row">
    <div class="form-group col-md-3">
      <label for="pNombre">Primer Nombre:</label>
      <input type="text" class="form-control" id="pNombre" v-model="pNombre" required :disabled="disabled">
    </div>
    <div class="form-group col-md-3">
      <label for="sNombre">Segundo Nombre:</label>
      <input type="text" class="form-control" id="sNombre" v-model="sNombre"  :disabled="disabled">
    </div>
    <div class="form-group col-md-3">
      <label for="pApellido">Primer Apellido:</label>
      <input type="text" class="form-control" id="pApellido" v-model="pApellido" required :disabled="disabled">
    </div>
    <div class="form-group col-md-3">
      <label for="sApellido">Segundo Apellido:</label>
      <input type="text" class="form-control" id="sApellido" v-model="sApellido" :disabled="disabled">
    </div>
  </div>
  <div class="form-row">
    <div class="form-group col-md-3">
      <label for="identidad">Identidad:</label>
      <input type="text" class="form-control" id="identidad" v-model="identidad" required="" :disabled="disabled">
    </div>
    <div class="form-group col-md-3">
      <label for="telefono">Telefono:</label>
      <input type="text" class="form-control" id="telefono" v-model="telefono" required="" :disabled="disabled">
    </div>
    <div class="form-group col-md-3">
      <label for="genero">Genero:</label>
      <select id="genero" class="form-control" required v-model="genero" :disabled="disabled">
        <option  value="">Choose...</option>
         <option :value="genero.idGenero" v-for="genero in  this.$store.state.generos">{{genero.genero}}</option>
      </select>
    </div>
    <div class="form-group col-md-3">
      <label for="sApellido">Fecha Nacimiento:</label>
	    <v-menu
	      ref="menu"
	      lazy
	      :close-on-content-click="false"
	      v-model="menu"
	      transition="scale-transition"
	      offset-y
	      full-width
	      :nudge-right="40"
	      min-width="290px"
	    >
	      <v-text-field
	        slot="activator"
	        v-model="date"
	        prepend-icon="event"
	        readonly
	        class="nonePadding"
	      ></v-text-field>
	      <v-date-picker
	        ref="picker"
	        v-model="date"
	        @change="save"
	        min="1950-01-01"
	        :max="new Date().toISOString().substr(0, 10)"
          :readonly="disabled"
	      ></v-date-picker>
	    </v-menu>
    </div>
  </div>
  <div class="form-row">
    <div class="form-group col-md-6">
      <label for="email">Correo Electronico:</label>
      <input type="email" class="form-control" id="email" placeholder="ejemplo@gmail.com" v-model="correo" required :disabled="disabled">
    </div>
  </div>
  
  <div class="form-row">
    <div class="form-group col-md-9">
      <label for="direccion">Direccion:</label>
      <input type="text" class="form-control" id="direccion" placeholder="Col Las Mercedes casa #4453" v-model="direccion" required :disabled="disabled">
    </div>
    <div class="form-group col-md-3">
      <label for="pais">Ciudad:</label>
      <select id="pais" class="form-control" required v-model="ciudad" :disabled="disabled">
        <option value="">Choose...</option>
        <option :value="ciudad.idCiudad" v-for="ciudad  in  this.$store.state.ciudades">{{ciudad.nombreCiudad}}</option>

      </select>
    </div>
    

  </div>
 
  <button v-if="!disabled" type="submit" class="btn btn-primary green" @click="guardarCliente">Guardar Cambios</button>
  <button v-if="disabled"  class="btn btn-secundaty orange" @click.prevent="editarCampos">Editar</button>
</form>
</template>

<script>
export default {
  mounted(){
    this.initValues();
  },
  data: () => ({
    date: null,
    menu: false,
    pNombre: "",
    sNombre: "",
    pApellido: "",
    sApellido: "",
    identidad: "",
    telefono: "",
    genero: "",
    correo: "",
    contrasena: "",
    confirmacion: "",
    direccion: "",
    pais: "",
    ciudad:"",
    ciudades:[],
    paises:[],
    generos:[],
    disabled:true
  }),
  watch: {
    menu (val) {
      val && this.$nextTick(() => (this.$refs.picker.activePicker = 'YEAR'))
    }
  },
  methods: {
    save (date) {
      this.$refs.menu.save(date)
    },
     async guardarCliente(){
       if(this.genero && this.direccion && this.pNombre && this.pApellido && this.date && this.identidad && this.correo){
        var params = new URLSearchParams();
        params.append('pNombre', this.pNombre);
        params.append('sNombre', this.sNombre);
        params.append('pApellido', this.pApellido);
        params.append('sApellido', this.sApellido);
        params.append('identidad', this.identidad);
        params.append('telefono', this.telefono);
        params.append('idGenero', this.genero);
        params.append('fechaNacimiento', this.date);
        params.append('correo', this.correo);
        params.append('direccion', this.direccion);
        params.append('idCiudad', this.ciudad);


        let respuesta = await Axios.post('/api/setters.php?opcion=2', params).then( resp =>  resp.data).catch(err => {console.log(err)});

          
        respuesta = await Axios.get('/api/getters.php?opcion=4').then( resp =>  resp.data).catch(err => {console.log(err)});

        
        this.$store.dispatch('guardarUsuario', {tipoUsuario : respuesta.tipoUsuario, codigoUsuario: respuesta.codigoUsuario});        

        this.editarCampos();

      }
    },
    editarCampos(){
      this.disabled = ! this.disabled;
    },
    initValues(){
      this.pNombre = this.$store.state.cliente.pNombre;
      this.sNombre = this.$store.state.cliente.sNombre
      this.pApellido = this.$store.state.cliente.pApellido
      this.sApellido = this.$store.state.cliente.sApellido
      this.identidad = this.$store.state.cliente.identidad
      this.telefono = this.$store.state.cliente.numeroTelefonico
      this.genero = this.$store.state.cliente.idGenero
      this.correo = this.$store.state.cliente.correoElectronico
      this.direccion = this.$store.state.cliente.descripcion
      this.ciudad = this.$store.state.cliente.idCiudad
      this.date = this.$store.state.cliente.fechaNacimiento.date.split(" ")[0]
    }
  }
}
</script>

<style>
	.nonePadding{
		padding: 0px;
	}
  .cuerpo{
    background-color: white !important;
  }
</style>