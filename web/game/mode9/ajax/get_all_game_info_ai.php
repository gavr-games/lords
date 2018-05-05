<?php
  include_once('init.php');
  //game f5 all info ai
	$tables = Array(
		Array(
			'name' =>'players',
		),
		Array(
			'name' =>'board_buildings',
		),
		Array(
			'name' =>'board_building_features',
		),
		Array(
			'name'=>'board_units',
		),
		Array(
			'name'=>'board_units_features',
		),
		Array(
			'name'=>'unit_levels',
		),
		Array(
			'name'=>'board',
		)
	);

	//in future need to secure get and post from injection in general
	$js_arrays = Array();
	$query = 'call '.$DB_conf['name'].'.get_all_game_info_ai('.$_GET['g_id'].','.$_GET['p_num'].');';
	$res = $dataBase->multi_query($query);
	foreach($tables as $table) {
			$result = $mysqli->store_result();
			while ($row = mysqli_fetch_assoc($result))	{
			  $js_arrays[$table["name"]][] = $row;
			}
			$result->free();
			$mysqli->next_result();
	}
	echo json_encode($js_arrays);
?>