<?php 
		// $bd = new Conexion();
		// sqlsrv_free_stmt( $stmt); 
		// $bd->cerrarConexion();
include_once("./clases/class-coneccion.php");
	session_start();
switch ($_GET['opcion']) {
	// verificar sesion
	case '1':
		$bd = new Conexion();

		$sql_exec_sp = '{call usp_validarInicioSesion( ?, ?, ?, ?)} ';


		$correo = $_POST["correo"];
		$pwd = $_POST["password"];
		$tipoUsuario = 0;
		$codigoUsuario = -1;

		$params = array(
				array($correo, SQLSRV_PARAM_IN),
				array($pwd, SQLSRV_PARAM_IN),
				array(&$tipoUsuario, SQLSRV_PARAM_INOUT),
				array(&$codigoUsuario, SQLSRV_PARAM_INOUT)
		);

		$stmt =  $bd->ejecutarParams($sql_exec_sp, $params);

		sqlsrv_next_result($stmt);
		$respuestaCliente= array();
		
		// tipoSesion puede ser: 0:no valida, 1:empleado, 2:cliente

		if ($tipoUsuario == 0) {
			$respuestaCliente["tipoUsuario"] = 0;
		}else if ($tipoUsuario == 1) {
			$respuestaCliente["tipoUsuario"] = 1;
			$respuestaCliente["codigoUsuario"] = $codigoUsuario;
			$_SESSION["empleado"] = $codigoUsuario;
		}else if ($tipoUsuario == 2) {
			$respuestaCliente["tipoUsuario"] = 2;
			$respuestaCliente["codigoUsuario"] = $codigoUsuario;
			$_SESSION["cliente"] = $codigoUsuario;
		}

		echo json_encode($respuestaCliente);

		sqlsrv_free_stmt( $stmt); 
		$bd->cerrarConexion();
	break;
	//obtiene un cliente
	case '2':
		$bd = new Conexion();
		$sql = "select pNombre, sNombre,  correoElectronico  from Personas p inner join Clientes c on c.idPersona = p.idPersona where c.idPersona = ".$_POST["idPersona"].";";

		$stmt = $bd->ejecutar($sql);

		$resp = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC);
		echo  json_encode($resp);
		
		$bd->cerrarConexion();
	break;
	//seleccionar generosPersonas
	case '3':
		$bd = new Conexion();

		$sql = 'select * from GenerosPersonas;';
		$stmt = $bd->ejecutar($sql);
		$generos= array();	
		while ($row = sqlsrv_fetch_object($stmt)) {
			if ($row->idGenero && sizeof($generos) < 10) {
				$generos[] = $row;
			}
		}

		echo json_encode($generos);

		sqlsrv_free_stmt( $stmt); 
		$bd->cerrarConexion();
	break;	
	//verifica si hay sesion iniciada
	case '4':
		$respuestaCliente = array();

		if ( isset($_SESSION["empleado"]) ) {
			$respuestaCliente["tipoUsuario"] = 1;
			$respuestaCliente["codigoUsuario"] = $_SESSION["empleado"];
		}else if( isset($_SESSION["cliente"]) ) {
			$respuestaCliente["tipoUsuario"] = 2;
			$respuestaCliente["codigoUsuario"] = $_SESSION["cliente"];
		}else{
			$respuestaCliente["tipoUsuario"] = 0;
		}

		echo json_encode($respuestaCliente);
	break;
	//obtiene un empleado
	case '5':
		$bd = new Conexion();
		$sql = "select pNombre, sNombre,  correoElectronico  from Personas p inner join Empleados e on e.idPersona = p.idPersona where e.idPersona = ".$_POST["idPersona"].";";

		$stmt = $bd->ejecutar($sql);

		$resp = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC);
		echo  json_encode($resp);
		

		$bd->cerrarConexion();
	break;
	//cierra sesion
	case '6':
		session_unset();
	break;
	case '7':
		$bd = new Conexion();

		$sql = 'select idCiudad, nombreCiudad from Ciudades where idPais = 12 ;';
		$stmt = $bd->ejecutar($sql);
		$paises= array();	
		while ($row = sqlsrv_fetch_object($stmt)) {
			if (sizeof($paises) < 3) {
				$paises[] = $row;
			}
		}

		echo json_encode($paises);

		sqlsrv_free_stmt( $stmt); 
		$bd->cerrarConexion();
	break;
	default:		
	break;
}

?>