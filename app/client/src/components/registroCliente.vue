<template>
	<form class="container">
	<div class="form-row">
    <div class="form-group col-md-3">
      <label for="pNombre">Primer Nombre:</label>
      <input type="text" class="form-control" id="pNombre" v-model="pNombre" required>
    </div>
    <div class="form-group col-md-3">
      <label for="sNombre">Segundo Nombre:</label>
      <input type="text" class="form-control" id="sNombre" v-model="sNombre" >
    </div>
    <div class="form-group col-md-3">
      <label for="pApellido">Primer Apellido:</label>
      <input type="text" class="form-control" id="pApellido" v-model="pApellido" required>
    </div>
    <div class="form-group col-md-3">
      <label for="sApellido">Segundo Apellido:</label>
      <input type="text" class="form-control" id="sApellido" v-model="sApellido">
    </div>
  </div>
  <div class="form-row">
    <div class="form-group col-md-3">
      <label for="identidad">Identidad:</label>
      <input type="text" class="form-control" id="identidad" v-model="identidad" required="">
    </div>
    <div class="form-group col-md-3">
      <label for="telefono">Telefono:</label>
      <input type="text" class="form-control" id="telefono" v-model="telefono" required="">
    </div>
    <div class="form-group col-md-3">
      <label for="fechaNacimiento">Genero:</label>
      <select id="pais" class="form-control" required>
        <option  value="">Choose...</option>
        <option value="eje">...</option>
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
	      ></v-date-picker>
	    </v-menu>
    </div>
  </div>
  <div class="form-row">
    <div class="form-group col-md-6">
      <label for="email">Correo Electronico:</label>
      <input type="email" class="form-control" id="email" placeholder="ejemplo@gmail.com" v-model="correo" required>
    </div>
    <div class="form-group col-md-3">
      <label for="contrasena">Contraseña:</label>
      <input type="password" class="form-control" id="contrasena" placeholder="contraseña" v-model="contrasena" required>
    </div>
    <div class="form-group col-md-3">
      <label for="confirmacion">Confirmar Contraseña:</label>
      <input type="password" class="form-control" id="confirmacion" placeholder="confirmacion" v-model="confirmacion" required>
    </div>
  </div>
  <div class="form-group">
    <label for="direccion">Direccion:</label>
    <input type="text" class="form-control" id="direccion" placeholder="Col Las Mercedes casa #4453" v-model="direccion" required>
  </div>
  <div class="form-row">
    <div class="form-group col-md-4">
      <label for="pais">Pais:</label>
      <select id="pais" class="form-control" required>
        <option value="">Choose...</option>
        <option value="eje">...</option>
      </select>
    </div>
    <div class="form-group col-md-4">
      <label for="ciudad">Ciudad:</label>
      <select id="ciudad" class="form-control" required="">
        <option value="">Choose...</option>
        <option value="eje">...</option>
      </select>
    </div>

  </div>
 
  <button type="submit" class="btn btn-primary" @click="guardarCliente">Sign in</button>
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
    Genero: 0,
    correo: "",
    contrasena: "",
    confirmacion: "",
    direccion: "",
    pais: 0,
    ciudad:"",
    ciudades:[],
    paises:[],
    generos:[]
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
    }
  }
}
</script>

<style>
	.nonePadding{
		padding: 0px;
	}
</style>