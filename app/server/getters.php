<?php 
include_once("./clases/class-coneccion.php");
$bd = new Conexion();

switch ($_GET['opcion']) {
	case '1':


	break;
	case '2':
		$sql = "select idCiudad, nombreCiudad from Ciudades c
						inner join Paises p on c.idPais = p.idPais
						where nombrePais = 'Honduras';";

	$stmt = $bd->ejecutar($sql);
	$ciudades= array();	
	while ($row = sqlsrv_fetch_object( $stmt )) {
			if ( sizeof($ciudades) < 3) {
				$ciudades[] = $row;
			}
	}
	print(json_encode($ciudades)) ;
	break;
	case '3':
		$sql = 'select * from GenerosPersonas;';
	$stmt = $bd->ejecutar($sql);
	$generos= array();	
		while ($row = sqlsrv_fetch_object($stmt)) {
			if ($row->idGenero && sizeof($generos) < 15) {
				$generos[] = $row;
			}
		}

	echo json_encode($generos);
	break;	
	default:
			# code...
	break;
}

$bd->cerrarConexion();
?>