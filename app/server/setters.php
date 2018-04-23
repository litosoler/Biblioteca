<?php 
		// $bd = new Conexion();
		// sqlsrv_free_stmt( $stmt); 
		// $bd->cerrarConexion();
include_once("./clases/class-coneccion.php");
	session_start();
switch ($_GET['opcion']) {
	// guardar Cliente
	case '1':
		echo json_encode($_POST);

		
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