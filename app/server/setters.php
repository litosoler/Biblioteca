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

		sqlsrv_free_stmt( $stmt); 
		$bd->cerrarConexion();
	break;
	// actualizar un Cliente
	case '2':
		$bd = new Conexion();

		$sql_exec_sp = '{call SP_actualizarCliente( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)} ';
		$idPersona 	= $_SESSION["cliente"];
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
				array($idPersona, SQLSRV_PARAM_IN),
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

		sqlsrv_free_stmt( $stmt); 
		$bd->cerrarConexion();
	break;
	//insertar una factura
	case '3':
		$bd = new Conexion();

		$sql_exec_sp = '{call SP_actualizarCliente( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)} ';
		$detalles		= $_POST["detalles"];
		$detalles = explode(',',$detalles);
		$idEmpleado 	= $_POST["idEmpleado"];
		$idCliente = $_POST["idCliente"];
		$idFormaPago		 = $_POST["idFormaPago"];
		$comentario		 = $_POST["comentario"];
		$idImpuesto		 = $_POST["idImpuesto"];
		$idFactura = "";
		$ocurrioError	 = 0;

		$params = array(
				array($detalles, SQLSRV_PARAM_IN),
				array($idEmpleado, SQLSRV_PARAM_IN),
				array($idCliente, SQLSRV_PARAM_IN),
				array($idFormaPago, SQLSRV_PARAM_IN),
				array($comentario, SQLSRV_PARAM_IN),				
				array($idImpuesto, SQLSRV_PARAM_IN),
				array(&$idFactura, SQLSRV_PARAM_IN),
		);

		$stmt =  $bd->ejecutarParams($sql_exec_sp, $params);
		
		$respuestaCliente= array();
		$respuestaCliente["mensaje"] = "";
		$respuestaCliente["ocurrioError"]= "";


		echo json_encode($respuestaCliente);

		$bd->cerrarConexion();
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