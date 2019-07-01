<?php
	include_once('init.php');

	if ($_SESSION['game_id']!='' && $_SESSION['player_num']!='')	{
		$query = 'call '.$DB_conf['name'].'.get_game_statistic('.$_SESSION['game_id'].');';
		Logger::info('statistic get -> '.$query);
		$res = $dataBase->multi_query($query);
		if ($res)	{
			$result = $mysqli->store_result();
			$js_strings = "var statistic = new Array();".PHP_EOL;
			$tab_id = '';
			$chart_id = '';
			$value_id = '';
			while ($row = mysqli_fetch_assoc($result))	{
				if ($tab_id != $row['tab_id']) {
					$js_strings .= "statistic[".$row['tab_id']."] = new Array();".PHP_EOL;
					$js_strings .= "statistic[".$row['tab_id']."]['charts'] = new Array();".PHP_EOL;
					$js_strings .= "statistic[".$row['tab_id']."]['tab_name'] = '".$row['tab_name']."';".PHP_EOL;
					$tab_id = $row['tab_id'];
				}
				if ($chart_id != $row['chart_id']) {
					$js_strings .= "statistic[".$row['tab_id']."]['charts'][".$row['chart_id']."] = new Array();".PHP_EOL;
					$js_strings .= "statistic[".$row['tab_id']."]['charts'][".$row['chart_id']."]['chart_name'] = '".$row['chart_name']."'".PHP_EOL;
					$js_strings .= "statistic[".$row['tab_id']."]['charts'][".$row['chart_id']."]['chart_type'] = '".$row['chart_type']."'".PHP_EOL;
					$js_strings .= "statistic[".$row['tab_id']."]['charts'][".$row['chart_id']."]['player_name'] = '".$row['player_name']."';".PHP_EOL;
					$js_strings .= "statistic[".$row['tab_id']."]['charts'][".$row['chart_id']."]['values'] = new Array();".PHP_EOL;
					$chart_id = $row['chart_id'];
				}
				if ($value_id != $row['value_id']) {
					$js_strings .= "statistic[".$row['tab_id']."]['charts'][".$row['chart_id']."]['values'][".$row['value_id']."] = new Array();".PHP_EOL;
					$js_strings .= "statistic[".$row['tab_id']."]['charts'][".$row['chart_id']."]['values'][".$row['value_id']."]['value'] = '".$row['value']."';".PHP_EOL;
					$js_strings .= "statistic[".$row['tab_id']."]['charts'][".$row['chart_id']."]['values'][".$row['value_id']."]['color'] = '".$row['color']."';".PHP_EOL;
					$js_strings .= "statistic[".$row['tab_id']."]['charts'][".$row['chart_id']."]['values'][".$row['value_id']."]['value_name'] = '".$row['value_name']."';".PHP_EOL;
					$value_id = $row['value_id'];
				}
			}
			$result->free();
			$mysqli->next_result();
			echo $js_strings;
		}
	} else echo 'Нужна авторизация';
?>