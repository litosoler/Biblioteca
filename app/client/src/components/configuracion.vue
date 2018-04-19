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
    guardarCliente(){
    	let parametros = `pNombre=${this.pNombre}&sNombre=${this.sNombre}&pApellido=${this.Apellido}&sApellido=${this.sApellido}&identidad=${this.identidad}&telefono=${this.telefono}&genero=${this.genero}&fechaNacimiento=${this.date}&correoElec=${this.correo}&contrasena=${this.contrasena}&confirmacion=${this.confirmacion}&direccion=${this.direccion}&pais=${this.pais}&ciudad=${this.ciudad}  `;

      if (this.pNombre && this.pApellido && this.identidad && this.genero && this.correo && this.direccion && this.ciudad) {
        this.editarCampos(); 
      }
    },
    editarCampos(){
      this.disabled = ! this.disabled;
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