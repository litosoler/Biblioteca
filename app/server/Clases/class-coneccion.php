<?php
	class Conexion{
		private $serverName = "den1.mssql6.gear.host"; //serverName\instanceName
		private $connectionInfo = array( "Database"=>"libreria", "UID"=>"libreria", "PWD"=>"asd.456", "CharacterSet" => "UTF-8");
		private $conn;

		public function __construct(){
			$this->conectar();
		}
		public function conectar(){
			$this->conn = sqlsrv_connect( $this->serverName, $this->connectionInfo);

			if( !$this->conn ){
				echo "Connection could not be established.<br />";
				die( print_r( sqlsrv_errors(), true));
			}
		}
		public function cerrarConexion(){
			sqlsrv_close( $this->conn );
		}
		public function ejecutar($sql){
			return sqlsrv_query( $this->conn, $sql);
		}
		public function ejecutarParams($sql, $params){
			return sqlsrv_query( $this->conn, $sql, $params);
		}
		public function obtenerFila($stmt){
			return mysqli_fetch_array($stmt);
		}

		public function getConn(){
			return $this->conn;
		}
		
		public function __toString(){
			return "Host: " . $this->host . 
				" Puerto: " . $this->puerto . 
				" Usuario: " . $this->usuario . 
				" Contrasena: " . $this->contrasena . 
				" BaseDatos: " . $this->baseDatos;
		}
	}
?>