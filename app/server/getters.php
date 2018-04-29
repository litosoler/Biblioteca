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
		$sql = "select p.idPersona, pNombre, sNombre, pApellido, sApellido, identidad, idGenero, fechaNacimiento, correoElectronico, t.numeroTelefonico, d.descripcion, idCiudad  from Personas p 
			inner join Clientes c on c.idPersona = p.idPersona 
			inner join Direcciones d on d.idDireccion = p.idDireccion
			left join Telefonos t on p.idPersona = t.idPersona
			where c.idPersona = ".$_POST["idPersona"].";";

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
		$sql = "select e.idPersona, pNombre, sNombre, pApellido, sApellido, identidad, idGenero, fechaNacimiento, correoElectronico, t.numeroTelefonico, d.descripcion, idCiudad  from Personas p 
			inner join empleados e on e.idPersona = p.idPersona 
			inner join Direcciones d on d.idDireccion = p.idDireccion
			left join Telefonos t on p.idPersona = t.idPersona
			where e.idPersona = ".$_POST["idPersona"].";";

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
				$paises[] = $row;
		}

		echo json_encode($paises);

		sqlsrv_free_stmt( $stmt); 
		$bd->cerrarConexion();
	break;
	//obtener la lista formas de pago
	case '8':
		$bd = new Conexion();
		$sql = 'select idFormaPago, descripcion from formasPago where estado = 1';

		$stmt = $bd->ejecutar($sql);

		$formasPago= array();

		while ($row = sqlsrv_fetch_object($stmt)) {
				$formasPago[] = $row;
		}

		echo json_encode($formasPago);


		$bd->cerrarConexion();
	break;
	//obtener clientes
	case '9':
		$bd = new Conexion();
		$sql = "Select p.identidad, c.idPersona from Clientes c inner join Personas p on p.idPersona = c.idPersona";
		$stmt = $bd->ejecutar($sql);		
		$listaClientes = array();
		while ($row = sqlsrv_fetch_object($stmt)) {
				$listaClientes[] = $row;
		}
		echo json_encode($listaClientes);

		$bd->cerrarConexion();
	break;
	//obtener libros
	case '10':
		$bd = new Conexion();
		$sql = 'select lib.nombreLibro,est.id ,est.idEstante,lib.precioVenta from LibrosXEstantes est
			inner join Libros lib on est.idLibro=lib.idLibro
			where idEstadoLibro=3';
		$stmt = $bd->ejecutar($sql);
		$libros= array();
		while ($row = sqlsrv_fetch_object($stmt)) {
				$libros[] = $row;
		}
		echo json_encode($libros);
		$bd->cerrarConexion();
	break;
	//libros comprados
	case '12':
		$bd = new Conexion();
		$sql = "Select l.nombreLibro, p.idPersona, f.fecha, l.precioVenta from Facturas f
				inner join Clientes c on c.idPersona = f.idCliente
				inner join Personas p on p.idPersona = c.idPersona
				inner join DetallesFacturas df on df.idFactura = f.idFactura
				inner join LibrosxEstantes le on le.id = df.idLibro
				inner join Libros l on l.idlibro = le.id
				where p.idPersona = ".$_POST["idPersona"].";";

		$stmt = $bd->ejecutar($sql);
		$libroscomprados=array();

		while ($row = sqlsrv_fetch_object($stmt)) {
			$libroscomprados[] = $row;
		}

		echo  json_encode($libroscomprados);
		

		$bd->cerrarConexion();
	break;
	//buscar libro por nombre
	case '13':
		$bd = new Conexion();

		// $sql_exec_sp = '{call SP_insertarCliente( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)} ';

		// $tipo			 = 1;
		// $cadena			 = "lad";//$_POST["cadena"];
		// $mensaje = "..........................................................";
		// $ocurrioError	 = 0;

		// $params = array(
		// 		array($tipo, SQLSRV_PARAM_IN),
		// 		array($cadena, SQLSRV_PARAM_IN),
		// 		array(&$mensaje, SQLSRV_PARAM_INOUT),
		// 		array(&$ocurrioError, SQLSRV_PARAM_INOUT)
		// );

		$sql = "Select * from libros l where l.nombreLibro like '%".$_POST["cadena"]."%'";

		$tabla = array();
		$stmt =  $bd->ejecutar( $sql);

		$row = sqlsrv_fetch_object($stmt);

		if( empty($row) ){

			$sql = "Select * from libros l ";

			$stmt =  $bd->ejecutar( $sql);

			while ($row = sqlsrv_fetch_object($stmt)) {
					$tabla[] = $row;
			}

		}else{
			$tabla[] = $row;
			while ($row = sqlsrv_fetch_object($stmt)) {
					$tabla[] = $row;
			}

		}
		
		// $respuestaCliente= array();
		// $mensaje = explode(".", $mensaje);
		// $respuestaCliente["mensaje"] = $mensaje[0];
		// $respuestaCliente["ocurrioError"]= $ocurrioError;
		// $respuestaCliente["tabla"]= $tabla;


		echo json_encode($tabla);
		$bd->cerrarConexion();
	break;
	

	default:		
	break;
}

?>