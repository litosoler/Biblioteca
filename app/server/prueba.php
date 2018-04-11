<?php
$serverName = "den1.mssql5.gear.host"; //serverName\instanceName
$connectionInfo = array( "Database"=>"libreria", "UID"=>"libreria", "PWD"=>"asd.456");
$conn = sqlsrv_connect( $serverName, $connectionInfo);

if( $conn ) {
	echo "Connection established.<br />";
	$sql = "select * from Libros";

	$stmt = sqlsrv_query( $conn, $sql);
	if( $stmt === false ) {
		die( print_r( sqlsrv_errors(), true));
	}else{
		echo "query exitosa\n";
		$resp = sqlsrv_fetch_array($stmt);
		echo json_encode($resp);
	}
}else{
     echo "Connection could not be established.<br />";
     die( print_r( sqlsrv_errors(), true));
}
?>