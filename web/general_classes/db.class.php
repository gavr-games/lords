<?php
class db {  
	var $hostname;
	var $username;
	var $password;
	var $dbName;
	var $mysqli;
	
	function db($hostname = "",$username = "",$password = "",$dbName = "")	{
		global 	$DB_conf;
		if ($hostname == "") $hostname = $DB_conf['server'];
		if ($username == "") $username = $DB_conf['user'];
		if ($password == "") $password = $DB_conf['pass'];
		if ($dbName == "")   $dbName = $DB_conf['name'];
		
		$this->hostname = $hostname; 
		$this->username = $username; 
		$this->password = $password; 
		$this->dbName = $dbName; 
	}
	function connect()	{
		MYSQL_CONNECT($this->hostname,$this->username,$this->password) OR DIE("Не могу создать соединение с базой данных.");
		@mysql_select_db("$this->dbName") or die("Не могу выбрать базу данных.");
		mysql_query("SET NAMES utf8"); 
		$this->mysqli = new mysqli($this->hostname, $this->username, $this->password, "$this->dbName");
		if (mysqli_connect_errno()) {
		    printf("Connect failed: %s\n", mysqli_connect_error());
		    die();
		}
	}
	function disconnect()	{
		MYSQL_CLOSE();	
		$this->mysqli->close();
	}
	function go($query)	{
		return MYSQL_QUERY($query);
	}
	function executePreparedStmt($q)	{
		$stmt =  $this->mysqli->stmt_init();
		
		if (!$stmt->prepare($q)) return false;
		if (!$stmt->execute()) return false;
		$stmt->bind_result($answer);
		$stmt->fetch();
		$stmt->close();
		
		return $answer;
	}
}
?>