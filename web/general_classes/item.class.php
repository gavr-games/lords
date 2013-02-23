<?php
class item
{
	var $table='';
	function item($tab)
	{
		$this->table=$tab;
	}
	function getOneItem($id)
	{
		global $db;
		$res = $db->go('SELECT * FROM '.$this->table.' WHERE id='.$id.' LIMIT 1');
		if ($res===false) return '';
		return mysql_fetch_assoc($res);
	}
	function getItems($condition='')
	{
		global $db;
		$result= array();
		$res = $db->go('SELECT * FROM '.$this->table.' '.$condition);
		if ($res===false) return '';
		while ($row=mysql_fetch_assoc($res))
		{
			$result[]=$row;
		}
		return $result;
	}
	function saveItem($data)
	{
		global $db;
		$ins_q='INSERT INTO '.$this->table.' SET ';
		$first=true;
		foreach($data as $key=>$value){
			if ($first){ $ins_q.=$key."='".$value."'"; $first=false;}else
				$ins_q.=", ".$key."='".$value."' ";
		}
		$db->go($ins_q);
		return mysql_insert_id();
	}
	function saveItems($data)
	{
		global $db;
		$ins_q='INSERT INTO '.$this->table.' ';
		$fields   = true;
		$first    = true;
		$firstRec = true;
		foreach($data as $record){
			if ($fields)	{
				$fields = false;
				foreach($record as $key=>$value)	{
					if ($first){ $ins_q .= ' ('.$key; $first=false;}else
					$ins_q .= ', '.$key;
				}
				$ins_q .= ') VALUES ';
			}
			$first = true;
			foreach($record as $key=>$value)	{
				if ($firstRec)	{
					if ($first){ $ins_q .= "('".$value."'"; $first=false;}else
						$ins_q .= ", '".$value."' ";
					$firstRec = false;
				} else 	{
					if ($first){ $ins_q .= ", ('".$value."'"; $first=false;}else
						$ins_q .= ", '".$value."' ";
				}
			}
			$ins_q .= ")";
		}
		$db->go($ins_q);
		return mysql_insert_id();
	}
	function updateItem($data,$id)
	{
		global $db;
		$ins_q='UPDATE '.$this->table.' SET ';
		$first=true;
		foreach($data as $key=>$value){
			if ($first){ $ins_q.=$key."='".$value."'"; $first=false;}else
				$ins_q.=", ".$key."='".$value."' ";
		}
		$ins_q.=' WHERE id='.$id;
		$db->go($ins_q);
		return mysql_insert_id();
	}
	function updateItems($data,$condition='')
	{
		global $db;
		$ins_q='UPDATE '.$this->table.' SET ';
		$first=true;
		foreach($data as $key=>$value){
			if ($first){ $ins_q.=$key."='".$value."'"; $first=false;}else
				$ins_q.=", ".$key."='".$value."' ";
		}
		$ins_q.=' '.$condition;
		$db->go($ins_q);
		return mysql_insert_id();
	}
	function deleteItem($id)
	{
		global $db;
		$res = $db->go('DELETE FROM '.$this->table.' WHERE id='.$id.' LIMIT 1');
		return $res;
	}
	function deleteItems($condition='')
	{
		global $db;
		$res = $db->go('DELETE FROM '.$this->table.' '.$condition);
		return $res;
	}
}
?>