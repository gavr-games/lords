<?php
/*
	02.02.2010
	Class for making queries to DataBase. Uses mysqli extension.
	Updated: 16.07.2010
*/
class cDataBase {
	
	var $dbLink  = '';
	var $debug   = true;
	
	function __construct($dbLink) {
		$this->dbLink = $dbLink;
	}
	
	//check for mysql errors and echo them in case of debug mode.
	function checkForErrors()	{
		if ($this->debug)	{
			$error = mysqli_error($this->dbLink);
			if ($error!='')	{
				//echo '<br /> <b>DataBase Error :</b> '.$error.'<br />';
				return false;
			}
		}
		return true;
	}
	
	//make select query from database. return false in case of error
	function select($fields,$table,$where='',$order='',$group='',$limit='')	{
		
		$query = 'SELECT '.$fields.' FROM '.$table;
		if ($where!='')
			$query .= ' WHERE '.$where;
		if ($order!='')
			$query .= ' ORDER BY '.$order;
		if ($group!='')
			$query .= ' GROUP BY '.$order;
		if ($limit!='')
			$query .= ' LIMIT '.$limit;
		
		$res = mysqli_query($this->dbLink,$query);
		
		if (!$this->checkForErrors()) return false;
		
		return $res;
	}
	
	//make delete query from database. return false in case of error
	function delete($table,$where='',$limit='')	{
		
		$query = 'DELETE FROM '.$table;
		if ($where!='') 
			$query .= ' WHERE '.$where;
		if ($limit!='')
			$query .= ' LIMIT '.$limit;
		
		$res = mysqli_query($this->dbLink,$query);
		
		if (!$this->checkForErrors()) return false;
		
		return $res;
	}
	
	//make insert query to database. return false in case of error. $data - array of 'name'=>'value'
	function insert($table,$data,$fields='')	{
		
		//insert 1 record
		if ($fields=='')	{
			$query = 'INSERT INTO '.$table.' SET ';
			$first = true;
			foreach($data as $key=>$value){
				if ($first){
					$query .= $key."='".$value."'";
					$first=false;
				}else
					$query .= ", ".$key."='".$value."' ";
			}
		} else 
		//insert many records
		{
			$query = 'INSERT INTO '.$table.' ';
			$first = $firstRec = true;
			
			$query .= ' ('.$fields.') VALUES ';
			
			foreach($data as $record){
				$first = true;
				foreach($record as $value)	{
					if ($firstRec)	{
						if ($first){
							$query .= "('".$value."'";
							$first=false;
						}else
							$query .= ", '".$value."' ";
						$firstRec = false;
					} else 	{
						if ($first){
							$query .= ", ('".$value."'";
							$first=false;
						}else
							$query .= ", '".$value."' ";
					}
				}
				$query .= ")";
			}
		}
		
		$res = mysqli_query($this->dbLink,$query);
		
		if (!$this->checkForErrors()) return false;
		
		return $res;
	}
	
	//make update query to database. return false in case of error. $data - array of 'name'=>'value'
	function update($table,$data,$where,$limit='')	{
		$query = 'UPDATE '.$table.' SET ';
		$first=true;
		foreach($data as $key=>$value){
			if ($first){
				$query .= $key."='".$value."'";
				$first  = false;
			}else
				$query .= ", ".$key."='".$value."' ";
		}
		$query .= ' WHERE '.$where;
		if ($limit!='')
			$query .= ' LIMIT '.$limit;
		
		$res = mysqli_query($this->dbLink,$query);
		
		if (!$this->checkForErrors()) return false;
		
		return $res;
	}
	
	//for different queries like call stored proc
	function query($query)	{
		mysqli_query($this->dbLink,"set @current_procedure_call='".$query."'");
		$res = mysqli_query($this->dbLink,$query);
		
		if (!$this->checkForErrors()) return false;
		
		return $res;
	}
	
	//for different multi queries like call stored proc multiple_actions
	function multi_query($query)	{
		mysqli_query($this->dbLink,"set @current_procedure_call='".$query."'");
		$res = mysqli_multi_query($this->dbLink,$query);
		
		if (!$this->checkForErrors()) return false;
		
		return $res;
	}
}
?>
