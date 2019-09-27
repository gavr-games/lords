<?php
	set_time_limit(0);
	include_once('init.php');
  session_commit();
  
  $info = [];

  // Get create_game_features
  $features_results = ['create_game_features'];
  $info['create_game_features'] = [];
  $query = 'call ' . $DB_conf['site'] . '.get_create_game_features(' . $_SESSION['user_id'] . ');';
  $res = $dataBase->multi_query($query);
  foreach ($features_results as $features_result) {
      $result = $mysqli->store_result();
      while ($row = mysqli_fetch_assoc($result)) {
          switch ($features_result) {
              case 'create_game_features':
                  $info['create_game_features'][] = $row;
                  break;
          }
      }
      $result->free();
      $mysqli->next_result();
  }

  // Get current game info
  $game_info_results = ['game', 'features', 'players'];
  $info['game'] = [];
  $info['features'] = [];
  $info['players'] = [];

  $query = 'call ' . $DB_conf['site'] . '.get_current_game_info(' . $_SESSION['user_id'] . ');';
  $res = $dataBase->multi_query($query);
  foreach ($game_info_results as $game_info_result) {
      $result = $mysqli->store_result();
      while ($row = mysqli_fetch_assoc($result)) {
        $info[$game_info_result][] = $row;
      }
      $result->free();
      $mysqli->next_result();
  }

  echo json_encode($info);
?>