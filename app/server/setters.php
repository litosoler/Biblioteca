<?php 
		// $bd = new Conexion();
		// sqlsrv_free_stmt( $stmt); 
		// $bd->cerrarConexion();
include_once("./clases/class-coneccion.php");
	session_start();
switch ($_GET['opcion']) {
	// guardar Cliente
	case '1':
		$bd = new Conexion();

		$sql_exec_sp = '{call SP_insertarCliente( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)} ';

		$pNombre			 = $_POST["pNombre"];
		$sNombre			 = $_POST["sNombre"];
		$pApellido		 = $_POST["pApellido"];
		$sApellido		 = $_POST["sApellido"];
		$identidad		 = $_POST["identidad"];
		$correoElectronico = $_POST["correo"];
		$password		 = $_POST["contrasena"];
		$idGenero		 = $_POST["idGenero"];
		$direccion			 = $_POST["direccion"];
		$idCiudad		 = $_POST["idCiudad"];
		$fechaNacimiento	 = $_POST["fechaNacimiento"];
		$mensaje = "..........................................................";
		$ocurrioError	 = 0;

		$params = array(
				array($pNombre, SQLSRV_PARAM_IN),
				array($sNombre, SQLSRV_PARAM_IN),
				array($pApellido, SQLSRV_PARAM_IN),
				array($sApellido, SQLSRV_PARAM_IN),				
				array($identidad, SQLSRV_PARAM_IN),
				array($correoElectronico, SQLSRV_PARAM_IN),
				array($password, SQLSRV_PARAM_IN),
				array($idGenero, SQLSRV_PARAM_IN),
				array($direccion, SQLSRV_PARAM_IN),
				array($idCiudad, SQLSRV_PARAM_IN),
				array($fechaNacimiento, SQLSRV_PARAM_IN),
				array(&$mensaje, SQLSRV_PARAM_INOUT),
				array(&$ocurrioError, SQLSRV_PARAM_INOUT)
		);

		$stmt =  $bd->ejecutarParams($sql_exec_sp, $params);
		
		$respuestaCliente= array();
		$mensaje = explode(".", $mensaje);
		$respuestaCliente["mensaje"] = $mensaje[0];
		$respuestaCliente["ocurrioError"]= $ocurrioError;


		echo json_encode($respuestaCliente);

		
	break;
	//obtiene un cliente
	case '2':
	break;
	//seleccionar generosPersonas
	case '3':
		
	break;	
	//verifica si hay sesion iniciada
	case '4':
		
	break;
	//obtiene un empleado
	case '5':
		
	break;
	//cierra sesion
	case '6':

	break;
	case '7':
		
	break;
	default:		
	break;
}

?>