<?php
	include_once('init.php');
	$_SESSION['tabs'] = '';
	if ($_SESSION['game_id']!='' && $_SESSION['player_num']!='')	{
		$query = 'call '.$DB_conf['name'].'.get_game_statistic('.$_SESSION['game_id'].');';
		$res = $dataBase->multi_query($query);
		if ($res)	{
			$result = $mysqli->store_result();
			while ($row = mysqli_fetch_assoc($result))	{
				$_SESSION['tabs'][$row['tab_id']]['name'] = $row['tab_name'];
				$_SESSION['tabs'][$row['tab_id']]['charts'][$row['chart_id']]['name'] = $row['chart_name'];
				$_SESSION['tabs'][$row['tab_id']]['charts'][$row['chart_id']]['type'] = $row['chart_type'];
				$_SESSION['tabs'][$row['tab_id']]['charts'][$row['chart_id']]['values'][$row['value_id']]['name']  = $row['value_name'];
				$_SESSION['tabs'][$row['tab_id']]['charts'][$row['chart_id']]['values'][$row['value_id']]['color'] = $row['color'];
				$_SESSION['tabs'][$row['tab_id']]['charts'][$row['chart_id']]['values'][$row['value_id']]['value'] = $row['value'];
			}
			$result->free();
			$mysqli->next_result();
		}
		$result = '';
		foreach($_SESSION['tabs'] as $tkey=>$tab) {
			$result .= "var myLi = new Element('li', {
					'title':'tab".$tkey."',
					'html':'".$tab['name']."'
				});myUl.grab(myLi,'bottom');";
			$result .="var myPanel = new Element('div', {
					'id':'tab".$tkey."',
					'class':'tabs_panel'
				});myDiv.grab(myPanel,'bottom');";
			foreach($tab['charts'] as $ckey=>$chart)	{
				$result .= "var myImg = new Element('img', {
					'src':'statistics/graph".$chart['type'].".php?tab_id=".$tkey."&chart_id=".$ckey."&timek=".time().rand(0,1000)."',
				});myPanel.grab(myImg,'bottom');";
			}
		}
		echo $result;
	} else echo 'Нужна авторизация';
?>