<?php
class Conexion
{
   private $host = "10.100.99.1";
   private $port = "5432";
   private $dbname = "sys8DD";
   private $user = "postgres";
   private $password = "Pokemon29";
   private $conexion;

   //postgres1 5432 postgres 123
   //postgres2 5433 postgres 123

   /*function _construct()
   {
      $this->host = "localhost";
      $this->port = "5432";
      $this->dbname = "tp_comunidad_vecinos";
      $this->user = "postgres";
      $this->password = "123";
   }*/

   function getConexion()
   {
      $this->conexion = pg_connect("host=$this->host port=$this->port dbname=$this->dbname user=$this->user password=$this->password");
      return $this->conexion;
   }

   function close()
   {
      pg_close($this->conexion);
   }

}


?>