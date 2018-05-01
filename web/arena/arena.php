<?php
include_once('init.php');

// Get where to redirect user
$query = 'call ' . $DB_conf['site'] . '.get_my_location(' . $_SESSION['user_id'] . ');'; //check where to redirect user
$res = $dataBase->multi_query($query);
$res = $mysqli->store_result();
$row = mysqli_fetch_assoc($res);
if ($row['game_type_id'] != '') {//go to general location
    if ($row['game_type_id'] == 0) header('location:' . $SITE_conf['domen']);
    if ($row['game_type_id'] == 1) { //arena game list
        if ($row['player_num'] != '') { //go to started game
            header('location:' . $SITE_conf['domen'] . 'game/mode' . $row['mode_id']);
        } else
            if ($row['game_id'] != '') { //go to not started game
                $iframe_link = 'arena_game.php?game_id=' . $row['game_id'];
            } else
                $iframe_link = 'arena_gamelist.php';
    }
}
$res->free();
$mysqli->next_result();

# Lang
$markers['###LOADING###'] = L::loading_text;
$markers['###EXIT###'] = L::do_exit;
$markers['###PROFILE###'] = L::profile_profile;

// Arena f5 info
$arena_info = array('players');
$markers['###JS_ARRAYS###'] .= 'var users = new Array();' . chr(13);
$markers['###JS_ARRAYS###'] .= 'var chats = new Array();' . chr(13);
$users = array();
$query = 'call ' . $DB_conf['site'] . '.get_all_arena_info(' . $_SESSION['user_id'] . ');';
$res = $dataBase->multi_query($query);
foreach ($arena_info as $info) {
    $result = $mysqli->store_result();
    while ($row = mysqli_fetch_assoc($result)) {
        switch ($info) {
            case 'players':
                $markers['###JS_ARRAYS###'] .= 'users[' . $row['user_id'] . '] = new Array();' . chr(13);
                $search = $replace = array();
                foreach ($row as $key => $value) {
                    $search[] = '###' . $key . '###';
                    $replace[] = $value;
                    $markers['###JS_ARRAYS###'] .= 'users[' . $row['user_id'] . ']["' . $key . '"] = "' . $value . '";' . chr(13);
                    $users[$row['user_id']][$key] = $value;
                }
                $markers['###PLAYERS###'] .= str_replace($search, $replace, $templates['player_in_playerslist']);
                break;
        }
    }
    $result->free();
    $mysqli->next_result();
}
// Chats
$path = '../design/images/pregame/smiles/Animated22/';
$arena_info = array('chats', 'chats_users');
$chats = array();

$markers['###JS_ARRAYS###'] .= 'chats[0] = new Array();' . chr(13);
$chats[0]['chat_id'] = 0;
$markers['###JS_ARRAYS###'] .= 'chats[0]["chat_id"] = 0;' . chr(13);
$chats[0]['topic'] = L::arena_chat_arena;
$markers['###JS_ARRAYS###'] .= 'chats[0]["topic"] = "Арена";' . chr(13);
$chats[0]['users'] = '';
$markers['###JS_ARRAYS###'] .= 'chats[0]["users"] = new Array();' . chr(13);

$query = 'call ' . $DB_conf['site'] . '.get_all_chat_info(' . $_SESSION['user_id'] . ');';
$res = $dataBase->multi_query($query);
foreach ($arena_info as $info) {
    $result = $mysqli->store_result();
    while ($row = mysqli_fetch_assoc($result)) {
        switch ($info) {
            case 'chats':
                $markers['###JS_ARRAYS###'] .= 'chats[' . $row['chat_id'] . '] = new Array();' . chr(13);
                $chats[$row['chat_id']]['chat_id'] = $row['chat_id'];
                $markers['###JS_ARRAYS###'] .= 'chats[' . $row['chat_id'] . ']["chat_id"] = ' . $row['chat_id'] . ';' . chr(13);
                $chats[$row['chat_id']]['topic'] = $row['topic'];
                if ($row['topic'] == '') $chats[$row['chat_id']]['notopic'] = 1; else $chats[$row['chat_id']]['notopic'] = 0;
                $markers['###JS_ARRAYS###'] .= 'chats[' . $row['chat_id'] . ']["topic"] = "' . $row['topic'] . '";' . chr(13);
                $chats[$row['chat_id']]['users'] = '';
                $markers['###JS_ARRAYS###'] .= 'chats[' . $row['chat_id'] . ']["users"] = new Array();' . chr(13);
                break;
            case 'chats_users':
                $search = $replace = array();
                foreach ($row as $key => $value) {
                    $search[] = '###' . $key . '###';
                    $replace[] = $value;
                }
                //print_r($row);
                $chats[$row['chat_id']]['users'] .= str_replace($search, $replace, $templates['chat_user']);
                $markers['###JS_ARRAYS###'] .= 'chats[' . $row['chat_id'] . ']["users"][' . $row['user_id'] . '] = ' . $row['user_id'] . ';' . chr(13);
                if ($chats[$row['chat_id']]['notopic']) $chats[$row['chat_id']]['topic'] .= $row['nick'] . ' ';
                break;
        }
    }
    $result->free();
    $mysqli->next_result();
}

// Form chats after f5
foreach ($chats as $chat_id => $chat_arr) {
    $search = $replace = array();
    foreach ($chat_arr as $key => $value) {
        $search[] = '###' . $key . '###';
        $replace[] = $value;
    }
    $markers['###CHAT_TOPICS_CONT###'] .= str_replace($search, $replace, $templates['chat_topic']);
    $markers['###CHAT_MESSAGES_CONT###'] .= str_replace($search, $replace, $templates['chat_messages']);
    $markers['###CHAT_USERS_CONT###'] .= str_replace($search, $replace, $templates['chat_users']);
}

// Some smiles :D
$allsmiles = '';
$handle = opendir($path); // open templates dir

while (($file = readdir($handle)) !== false) {
    if (strlen($file) > 3) {//no "." or ".."
        $name = explode('.', $file);
        if ($name[1] == 'gif') {//no readme.txt or smth else
            $search = $replace = array();
            $search[] = '###src###';
            $replace[] = $path . $file;
            $search[] = '###code###';
            $replace[] = '*' . $name[0] . '*';
            $allsmiles .= str_replace($search, $replace, $templates['smile']);
        }
    }
}
closedir($handle);
$markers['###ALL_SMILES###'] = $allsmiles;

$markers['###JS_ARRAYS###'] .= 'my_user_id = ' . $_SESSION['user_id'] . ';' . chr(13);

// Proccess markers
$markers['###JS_ARRAYS###'] .= $js_arrays;
$markers['###IFRAME_LINK###'] = $iframe_link;
$markers['###REVISION###'] = $SITE_conf['revision'];
$copyYear = 2010;
$curYear = date('Y');
$markers['###COPY###'] = '© ' . $copyYear . (($copyYear != $curYear) ? '-' . $curYear : '') . ' "THE LORDS"';
$markers['###USER_LANGUAGE###'] = LangUtils::getCurrentLangNumber($_SESSION['lang']);

// Print template of html page
$replace = $values = array();
foreach ($markers as $key => $value) {
    $replace[] = $key;
    $values[] = $value;
}
echo LangUtils::replaceTemplateMarkers(str_replace($replace, $values, file_get_contents('arena.html')));
?>