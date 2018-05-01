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

		$sql_exec_sp = '{call SP_insertarCliente( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)} ';

		$pNombre			 = $_POST["pNombre"];
		$sNombre			 = $_POST["sNombre"];
		$pApellido		 = $_POST["pApellido"];
		$sApellido		 = $_POST["sApellido"];
		$identidad		 = $_POST["identidad"];
		$correoElectronico = $_POST["correo"];
		$telefono = $_POST["telefono"];
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
				array($telefono, SQLSRV_PARAM_IN),
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
 
		$bd->cerrarConexion();
	break;
	// actualizar un Cliente
	case '2':
		$bd = new Conexion();

		$sql_exec_sp = '{call SP_actualizarCliente( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)} ';
		$idPersona 	= $_SESSION["cliente"];
		$pNombre			 = $_POST["pNombre"];
		$sNombre			 = $_POST["sNombre"];
		$pApellido		 = $_POST["pApellido"];
		$sApellido		 = $_POST["sApellido"];
		$identidad		 = $_POST["identidad"];
		$telefono		 = $_POST["telefono"];
		$correoElectronico = $_POST["correo"];
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
				array($telefono, SQLSRV_PARAM_IN),
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

		$bd->cerrarConexion();
	break;
	//insertar una factura
	case '3':
		$bd = new Conexion();

		$sql_exec_sp = "{call SP_crearFactura( ?, ?, ?, ?, ?, ?, ?, ?,?)} ";
		$idEmpleado 	= $_POST["idEmpleado"];
		$idCliente = $_POST["idCliente"];
		$idFormaPago		 = $_POST["idFormaPago"];
		$comentario		 = $_POST["comentario"];
		$idImpuesto		 = $_POST["idImpuesto"];
		$idFactura = 0;
		$mensaje = "";
		$error = 0;
		$idDescuento = 2;


		$sql_exec_sp_2 = '{call SP_insertarDetallesFacturas( ?, ?, ?, ?, ?)} ';
		$detalles		= $_POST["detalles"];
		$detalles = explode(',',$detalles);

		$respuestaCliente = [];


		$params = array(
				array($idEmpleado, SQLSRV_PARAM_IN),
				array($idCliente, SQLSRV_PARAM_IN),
				array($idFormaPago, SQLSRV_PARAM_IN),
				array($comentario, SQLSRV_PARAM_IN),				
				array($idImpuesto, SQLSRV_PARAM_IN),
				array($idDescuento, SQLSRV_PARAM_IN),
				array(&$idFactura, SQLSRV_PARAM_INOUT),
				array(&$mensaje, SQLSRV_PARAM_INOUT),
				array(&$error, SQLSRV_PARAM_INOUT),
		);

		$stmt =  $bd->ejecutarParams($sql_exec_sp, $params);

		$sql = "select max(idFactura) id from Facturas";

		$stmt = $bd->ejecutar($sql);

		$row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC);

		$idFactura = $row["id"];

		if ($idFactura != 0) {
			for($i = 0; $i < sizeof($detalles); $i++){
				$params = array(
					array($detalles[$i], SQLSRV_PARAM_IN),
					array($idCliente, SQLSRV_PARAM_IN),
					array($idFactura, SQLSRV_PARAM_IN),
					array(&$mensaje, SQLSRV_PARAM_INOUT),
					array(&$error, SQLSRV_PARAM_INOUT),
				);

				$stmt =  $bd->ejecutarParams($sql_exec_sp_2, $params);

				$respuestaCliente[] = $mensaje;

			}
		}else{
			$respuestaCliente[] = "factura no ingresada";
		}

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