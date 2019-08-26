<?php
	set_time_limit(0);
	include_once('init.php');
  session_commit();
  
  $info = [];

  // Arena f5 info
  $arena_info_results = ['players'];
  $info['players'] = [];
  $query = 'call ' . $DB_conf['site'] . '.get_all_arena_info(' . $_SESSION['user_id'] . ');';
  $res = $dataBase->multi_query($query);
  foreach ($arena_info_results as $arena_info_result) {
      $result = $mysqli->store_result();
      while ($row = mysqli_fetch_assoc($result)) {
          switch ($arena_info_result) {
              case 'players':
                  $info['players'][] = $row;
                  break;
          }
      }
      $result->free();
      $mysqli->next_result();
  }

  // Chats
  $chat_info_results = ['chats', 'chats_users'];
  $info['chats'] = [];
  $info['chats_users'] = [];

  $query = 'call ' . $DB_conf['site'] . '.get_all_chat_info(' . $_SESSION['user_id'] . ');';
  $res = $dataBase->multi_query($query);
  foreach ($chat_info_results as $chat_info_result) {
      $result = $mysqli->store_result();
      while ($row = mysqli_fetch_assoc($result)) {
          switch ($chat_info_result) {
              case 'chats':
                  $info['chats'][] = $row;
                  break;
              case 'chats_users':
                  $info['chats_users'][] = $row;
                  break;
          }
      }
      $result->free();
      $mysqli->next_result();
  }

  echo json_encode($info);
?>