
var dic_game_types = new Array();
dic_game_types["1"] = new Array();
dic_game_types["1"]["id"] = "1";
dic_game_types["1"]["description"] = "arena";
dic_game_types["2"] = new Array();
dic_game_types["2"]["id"] = "2";
dic_game_types["2"]["description"] = "league";
dic_game_types["3"] = new Array();
dic_game_types["3"]["id"] = "3";
dic_game_types["3"]["description"] = "campaign";

var dic_player_status = new Array();
dic_player_status["1"] = new Array();
dic_player_status["1"]["1"] = new Array();
dic_player_status["1"]["1"]["id"] = "5";
dic_player_status["1"]["1"]["player_status_id"] = "1";
dic_player_status["1"]["1"]["language_id"] = "1";
dic_player_status["1"]["1"]["description"] = "Online";
dic_player_status["1"]["2"] = new Array();
dic_player_status["1"]["2"]["id"] = "6";
dic_player_status["1"]["2"]["player_status_id"] = "2";
dic_player_status["1"]["2"]["language_id"] = "1";
dic_player_status["1"]["2"]["description"] = "Waiting for a game to start";
dic_player_status["1"]["3"] = new Array();
dic_player_status["1"]["3"]["id"] = "7";
dic_player_status["1"]["3"]["player_status_id"] = "3";
dic_player_status["1"]["3"]["language_id"] = "1";
dic_player_status["1"]["3"]["description"] = "In game";
dic_player_status["1"]["4"] = new Array();
dic_player_status["1"]["4"]["id"] = "8";
dic_player_status["1"]["4"]["player_status_id"] = "4";
dic_player_status["1"]["4"]["language_id"] = "1";
dic_player_status["1"]["4"]["description"] = "Offline";
dic_player_status["2"] = new Array();
dic_player_status["2"]["1"] = new Array();
dic_player_status["2"]["1"]["id"] = "1";
dic_player_status["2"]["1"]["player_status_id"] = "1";
dic_player_status["2"]["1"]["language_id"] = "2";
dic_player_status["2"]["1"]["description"] = "Онлайн";
dic_player_status["2"]["2"] = new Array();
dic_player_status["2"]["2"]["id"] = "2";
dic_player_status["2"]["2"]["player_status_id"] = "2";
dic_player_status["2"]["2"]["language_id"] = "2";
dic_player_status["2"]["2"]["description"] = "Ждет старта игры";
dic_player_status["2"]["3"] = new Array();
dic_player_status["2"]["3"]["id"] = "3";
dic_player_status["2"]["3"]["player_status_id"] = "3";
dic_player_status["2"]["3"]["language_id"] = "2";
dic_player_status["2"]["3"]["description"] = "В игре";
dic_player_status["2"]["4"] = new Array();
dic_player_status["2"]["4"]["id"] = "4";
dic_player_status["2"]["4"]["player_status_id"] = "4";
dic_player_status["2"]["4"]["language_id"] = "2";
dic_player_status["2"]["4"]["description"] = "Офлайн";

var error_dictionary_messages = new Array();
error_dictionary_messages["1"] = new Array();
error_dictionary_messages["1"]["1"] = new Array();
error_dictionary_messages["1"]["1"]["id"] = "36";
error_dictionary_messages["1"]["1"]["error_id"] = "1";
error_dictionary_messages["1"]["1"]["language_id"] = "1";
error_dictionary_messages["1"]["1"]["description"] = "Login {0} already exists";
error_dictionary_messages["1"]["2"] = new Array();
error_dictionary_messages["1"]["2"]["id"] = "37";
error_dictionary_messages["1"]["2"]["error_id"] = "2";
error_dictionary_messages["1"]["2"]["language_id"] = "1";
error_dictionary_messages["1"]["2"]["description"] = "Blank login or password";
error_dictionary_messages["1"]["3"] = new Array();
error_dictionary_messages["1"]["3"]["id"] = "38";
error_dictionary_messages["1"]["3"]["error_id"] = "3";
error_dictionary_messages["1"]["3"]["language_id"] = "1";
error_dictionary_messages["1"]["3"]["description"] = "Incorrect login or password";
error_dictionary_messages["1"]["4"] = new Array();
error_dictionary_messages["1"]["4"]["id"] = "39";
error_dictionary_messages["1"]["4"]["error_id"] = "4";
error_dictionary_messages["1"]["4"]["language_id"] = "1";
error_dictionary_messages["1"]["4"]["description"] = "Incorrect user_id";
error_dictionary_messages["1"]["5"] = new Array();
error_dictionary_messages["1"]["5"]["id"] = "40";
error_dictionary_messages["1"]["5"]["error_id"] = "5";
error_dictionary_messages["1"]["5"]["language_id"] = "1";
error_dictionary_messages["1"]["5"]["description"] = "Incorrect chat_id";
error_dictionary_messages["1"]["6"] = new Array();
error_dictionary_messages["1"]["6"]["id"] = "41";
error_dictionary_messages["1"]["6"]["error_id"] = "6";
error_dictionary_messages["1"]["6"]["language_id"] = "1";
error_dictionary_messages["1"]["6"]["description"] = "You are not in this chat";
error_dictionary_messages["1"]["7"] = new Array();
error_dictionary_messages["1"]["7"]["id"] = "42";
error_dictionary_messages["1"]["7"]["error_id"] = "7";
error_dictionary_messages["1"]["7"]["language_id"] = "1";
error_dictionary_messages["1"]["7"]["description"] = "You cannot change the topic of the common chat";
error_dictionary_messages["1"]["8"] = new Array();
error_dictionary_messages["1"]["8"]["id"] = "43";
error_dictionary_messages["1"]["8"]["error_id"] = "8";
error_dictionary_messages["1"]["8"]["language_id"] = "1";
error_dictionary_messages["1"]["8"]["description"] = "You are not in the Arena";
error_dictionary_messages["1"]["9"] = new Array();
error_dictionary_messages["1"]["9"]["id"] = "44";
error_dictionary_messages["1"]["9"]["error_id"] = "9";
error_dictionary_messages["1"]["9"]["language_id"] = "1";
error_dictionary_messages["1"]["9"]["description"] = "Time restriction should be positive";
error_dictionary_messages["1"]["10"] = new Array();
error_dictionary_messages["1"]["10"]["id"] = "45";
error_dictionary_messages["1"]["10"]["error_id"] = "10";
error_dictionary_messages["1"]["10"]["language_id"] = "1";
error_dictionary_messages["1"]["10"]["description"] = "Mode does not exist";
error_dictionary_messages["1"]["11"] = new Array();
error_dictionary_messages["1"]["11"]["id"] = "46";
error_dictionary_messages["1"]["11"]["error_id"] = "11";
error_dictionary_messages["1"]["11"]["language_id"] = "1";
error_dictionary_messages["1"]["11"]["description"] = "Only game creator can add or remove game features";
error_dictionary_messages["1"]["12"] = new Array();
error_dictionary_messages["1"]["12"]["id"] = "47";
error_dictionary_messages["1"]["12"]["error_id"] = "12";
error_dictionary_messages["1"]["12"]["language_id"] = "1";
error_dictionary_messages["1"]["12"]["description"] = "There is no such game feachure for this game";
error_dictionary_messages["1"]["13"] = new Array();
error_dictionary_messages["1"]["13"]["id"] = "48";
error_dictionary_messages["1"]["13"]["error_id"] = "13";
error_dictionary_messages["1"]["13"]["language_id"] = "1";
error_dictionary_messages["1"]["13"]["description"] = "Incorrect game password";
error_dictionary_messages["1"]["14"] = new Array();
error_dictionary_messages["1"]["14"]["id"] = "49";
error_dictionary_messages["1"]["14"]["error_id"] = "14";
error_dictionary_messages["1"]["14"]["language_id"] = "1";
error_dictionary_messages["1"]["14"]["description"] = "You are already in another game";
error_dictionary_messages["1"]["15"] = new Array();
error_dictionary_messages["1"]["15"]["id"] = "50";
error_dictionary_messages["1"]["15"]["error_id"] = "15";
error_dictionary_messages["1"]["15"]["language_id"] = "1";
error_dictionary_messages["1"]["15"]["description"] = "You cannot add or remove game features after the game has started";
error_dictionary_messages["1"]["16"] = new Array();
error_dictionary_messages["1"]["16"]["id"] = "51";
error_dictionary_messages["1"]["16"]["error_id"] = "16";
error_dictionary_messages["1"]["16"]["language_id"] = "1";
error_dictionary_messages["1"]["16"]["description"] = "Game does not exist";
error_dictionary_messages["1"]["17"] = new Array();
error_dictionary_messages["1"]["17"]["id"] = "52";
error_dictionary_messages["1"]["17"]["error_id"] = "17";
error_dictionary_messages["1"]["17"]["language_id"] = "1";
error_dictionary_messages["1"]["17"]["description"] = "You cannot enter the game after its start";
error_dictionary_messages["1"]["18"] = new Array();
error_dictionary_messages["1"]["18"]["id"] = "53";
error_dictionary_messages["1"]["18"]["error_id"] = "18";
error_dictionary_messages["1"]["18"]["language_id"] = "1";
error_dictionary_messages["1"]["18"]["description"] = "Incorrect spectator_flag";
error_dictionary_messages["1"]["19"] = new Array();
error_dictionary_messages["1"]["19"]["id"] = "54";
error_dictionary_messages["1"]["19"]["error_id"] = "19";
error_dictionary_messages["1"]["19"]["language_id"] = "1";
error_dictionary_messages["1"]["19"]["description"] = "Only game creator can modify teams";
error_dictionary_messages["1"]["20"] = new Array();
error_dictionary_messages["1"]["20"]["id"] = "55";
error_dictionary_messages["1"]["20"]["error_id"] = "20";
error_dictionary_messages["1"]["20"]["language_id"] = "1";
error_dictionary_messages["1"]["20"]["description"] = "You cannot modify teams after the game has started";
error_dictionary_messages["1"]["21"] = new Array();
error_dictionary_messages["1"]["21"]["id"] = "56";
error_dictionary_messages["1"]["21"]["error_id"] = "21";
error_dictionary_messages["1"]["21"]["language_id"] = "1";
error_dictionary_messages["1"]["21"]["description"] = "This player is not in this game";
error_dictionary_messages["1"]["22"] = new Array();
error_dictionary_messages["1"]["22"]["id"] = "57";
error_dictionary_messages["1"]["22"]["error_id"] = "22";
error_dictionary_messages["1"]["22"]["language_id"] = "1";
error_dictionary_messages["1"]["22"]["description"] = "Only game creator can remove a player";
error_dictionary_messages["1"]["23"] = new Array();
error_dictionary_messages["1"]["23"]["id"] = "58";
error_dictionary_messages["1"]["23"]["error_id"] = "23";
error_dictionary_messages["1"]["23"]["language_id"] = "1";
error_dictionary_messages["1"]["23"]["description"] = "You cannot remove a player after the game has started";
error_dictionary_messages["1"]["24"] = new Array();
error_dictionary_messages["1"]["24"]["id"] = "59";
error_dictionary_messages["1"]["24"]["error_id"] = "24";
error_dictionary_messages["1"]["24"]["language_id"] = "1";
error_dictionary_messages["1"]["24"]["description"] = "You cannot leave the common chat";
error_dictionary_messages["1"]["25"] = new Array();
error_dictionary_messages["1"]["25"]["id"] = "60";
error_dictionary_messages["1"]["25"]["error_id"] = "25";
error_dictionary_messages["1"]["25"]["language_id"] = "1";
error_dictionary_messages["1"]["25"]["description"] = "Incorrect team";
error_dictionary_messages["1"]["26"] = new Array();
error_dictionary_messages["1"]["26"]["id"] = "61";
error_dictionary_messages["1"]["26"]["error_id"] = "26";
error_dictionary_messages["1"]["26"]["language_id"] = "1";
error_dictionary_messages["1"]["26"]["description"] = "Only game creator can start the game";
error_dictionary_messages["1"]["27"] = new Array();
error_dictionary_messages["1"]["27"]["id"] = "62";
error_dictionary_messages["1"]["27"]["error_id"] = "27";
error_dictionary_messages["1"]["27"]["language_id"] = "1";
error_dictionary_messages["1"]["27"]["description"] = "The game is already started";
error_dictionary_messages["1"]["28"] = new Array();
error_dictionary_messages["1"]["28"]["id"] = "63";
error_dictionary_messages["1"]["28"]["error_id"] = "28";
error_dictionary_messages["1"]["28"]["language_id"] = "1";
error_dictionary_messages["1"]["28"]["description"] = "Incorrect number of players";
error_dictionary_messages["1"]["29"] = new Array();
error_dictionary_messages["1"]["29"]["id"] = "64";
error_dictionary_messages["1"]["29"]["error_id"] = "29";
error_dictionary_messages["1"]["29"]["language_id"] = "1";
error_dictionary_messages["1"]["29"]["description"] = "The game is not started yet";
error_dictionary_messages["1"]["30"] = new Array();
error_dictionary_messages["1"]["30"]["id"] = "65";
error_dictionary_messages["1"]["30"]["error_id"] = "30";
error_dictionary_messages["1"]["30"]["language_id"] = "1";
error_dictionary_messages["1"]["30"]["description"] = "The user has already started a game in Arena";
error_dictionary_messages["1"]["31"] = new Array();
error_dictionary_messages["1"]["31"]["id"] = "66";
error_dictionary_messages["1"]["31"]["error_id"] = "31";
error_dictionary_messages["1"]["31"]["language_id"] = "1";
error_dictionary_messages["1"]["31"]["description"] = "You cannot leave Arena while you are in game {0}";
error_dictionary_messages["1"]["32"] = new Array();
error_dictionary_messages["1"]["32"]["id"] = "67";
error_dictionary_messages["1"]["32"]["error_id"] = "32";
error_dictionary_messages["1"]["32"]["language_id"] = "1";
error_dictionary_messages["1"]["32"]["description"] = "You are already in this chat";
error_dictionary_messages["1"]["33"] = new Array();
error_dictionary_messages["1"]["33"]["id"] = "68";
error_dictionary_messages["1"]["33"]["error_id"] = "33";
error_dictionary_messages["1"]["33"]["language_id"] = "1";
error_dictionary_messages["1"]["33"]["description"] = "Incorrect value for game feature game_feature_id={0}";
error_dictionary_messages["1"]["34"] = new Array();
error_dictionary_messages["1"]["34"]["id"] = "69";
error_dictionary_messages["1"]["34"]["error_id"] = "34";
error_dictionary_messages["1"]["34"]["language_id"] = "1";
error_dictionary_messages["1"]["34"]["description"] = "You cannot open a chat with yourself";
error_dictionary_messages["1"]["35"] = new Array();
error_dictionary_messages["1"]["35"]["id"] = "70";
error_dictionary_messages["1"]["35"]["error_id"] = "35";
error_dictionary_messages["1"]["35"]["language_id"] = "1";
error_dictionary_messages["1"]["35"]["description"] = "Unknown language code: {0}";
error_dictionary_messages["2"] = new Array();
error_dictionary_messages["2"]["1"] = new Array();
error_dictionary_messages["2"]["1"]["id"] = "1";
error_dictionary_messages["2"]["1"]["error_id"] = "1";
error_dictionary_messages["2"]["1"]["language_id"] = "2";
error_dictionary_messages["2"]["1"]["description"] = "Логин {0} существует";
error_dictionary_messages["2"]["2"] = new Array();
error_dictionary_messages["2"]["2"]["id"] = "2";
error_dictionary_messages["2"]["2"]["error_id"] = "2";
error_dictionary_messages["2"]["2"]["language_id"] = "2";
error_dictionary_messages["2"]["2"]["description"] = "Пустой логин или пароль";
error_dictionary_messages["2"]["3"] = new Array();
error_dictionary_messages["2"]["3"]["id"] = "3";
error_dictionary_messages["2"]["3"]["error_id"] = "3";
error_dictionary_messages["2"]["3"]["language_id"] = "2";
error_dictionary_messages["2"]["3"]["description"] = "Неверный логин или пароль";
error_dictionary_messages["2"]["4"] = new Array();
error_dictionary_messages["2"]["4"]["id"] = "4";
error_dictionary_messages["2"]["4"]["error_id"] = "4";
error_dictionary_messages["2"]["4"]["language_id"] = "2";
error_dictionary_messages["2"]["4"]["description"] = "Неправильный user_id";
error_dictionary_messages["2"]["5"] = new Array();
error_dictionary_messages["2"]["5"]["id"] = "5";
error_dictionary_messages["2"]["5"]["error_id"] = "5";
error_dictionary_messages["2"]["5"]["language_id"] = "2";
error_dictionary_messages["2"]["5"]["description"] = "Неправильный chat_id";
error_dictionary_messages["2"]["6"] = new Array();
error_dictionary_messages["2"]["6"]["id"] = "6";
error_dictionary_messages["2"]["6"]["error_id"] = "6";
error_dictionary_messages["2"]["6"]["language_id"] = "2";
error_dictionary_messages["2"]["6"]["description"] = "Вас нет в этом чате";
error_dictionary_messages["2"]["7"] = new Array();
error_dictionary_messages["2"]["7"]["id"] = "7";
error_dictionary_messages["2"]["7"]["error_id"] = "7";
error_dictionary_messages["2"]["7"]["language_id"] = "2";
error_dictionary_messages["2"]["7"]["description"] = "Нельзя изменить тему общего чата";
error_dictionary_messages["2"]["8"] = new Array();
error_dictionary_messages["2"]["8"]["id"] = "8";
error_dictionary_messages["2"]["8"]["error_id"] = "8";
error_dictionary_messages["2"]["8"]["language_id"] = "2";
error_dictionary_messages["2"]["8"]["description"] = "Вас нет в арене";
error_dictionary_messages["2"]["9"] = new Array();
error_dictionary_messages["2"]["9"]["id"] = "9";
error_dictionary_messages["2"]["9"]["error_id"] = "9";
error_dictionary_messages["2"]["9"]["language_id"] = "2";
error_dictionary_messages["2"]["9"]["description"] = "Ограничение по времени должно быть положительным";
error_dictionary_messages["2"]["10"] = new Array();
error_dictionary_messages["2"]["10"]["id"] = "10";
error_dictionary_messages["2"]["10"]["error_id"] = "10";
error_dictionary_messages["2"]["10"]["language_id"] = "2";
error_dictionary_messages["2"]["10"]["description"] = "Нет такого мода";
error_dictionary_messages["2"]["11"] = new Array();
error_dictionary_messages["2"]["11"]["id"] = "11";
error_dictionary_messages["2"]["11"]["error_id"] = "11";
error_dictionary_messages["2"]["11"]["language_id"] = "2";
error_dictionary_messages["2"]["11"]["description"] = "Только создатель игры может добавлять и удалять фичи";
error_dictionary_messages["2"]["12"] = new Array();
error_dictionary_messages["2"]["12"]["id"] = "12";
error_dictionary_messages["2"]["12"]["error_id"] = "12";
error_dictionary_messages["2"]["12"]["language_id"] = "2";
error_dictionary_messages["2"]["12"]["description"] = "Для этой игры нет такой фичи";
error_dictionary_messages["2"]["13"] = new Array();
error_dictionary_messages["2"]["13"]["id"] = "13";
error_dictionary_messages["2"]["13"]["error_id"] = "13";
error_dictionary_messages["2"]["13"]["language_id"] = "2";
error_dictionary_messages["2"]["13"]["description"] = "Неправильный пароль к игре";
error_dictionary_messages["2"]["14"] = new Array();
error_dictionary_messages["2"]["14"]["id"] = "14";
error_dictionary_messages["2"]["14"]["error_id"] = "14";
error_dictionary_messages["2"]["14"]["language_id"] = "2";
error_dictionary_messages["2"]["14"]["description"] = "Вы уже находитесь в другой игре";
error_dictionary_messages["2"]["15"] = new Array();
error_dictionary_messages["2"]["15"]["id"] = "15";
error_dictionary_messages["2"]["15"]["error_id"] = "15";
error_dictionary_messages["2"]["15"]["language_id"] = "2";
error_dictionary_messages["2"]["15"]["description"] = "Нельзя добавлять и удалять фичи после начала игры";
error_dictionary_messages["2"]["16"] = new Array();
error_dictionary_messages["2"]["16"]["id"] = "16";
error_dictionary_messages["2"]["16"]["error_id"] = "16";
error_dictionary_messages["2"]["16"]["language_id"] = "2";
error_dictionary_messages["2"]["16"]["description"] = "Нет такой игры";
error_dictionary_messages["2"]["17"] = new Array();
error_dictionary_messages["2"]["17"]["id"] = "17";
error_dictionary_messages["2"]["17"]["error_id"] = "17";
error_dictionary_messages["2"]["17"]["language_id"] = "2";
error_dictionary_messages["2"]["17"]["description"] = "Нельзя войти в игру после начала игры";
error_dictionary_messages["2"]["18"] = new Array();
error_dictionary_messages["2"]["18"]["id"] = "18";
error_dictionary_messages["2"]["18"]["error_id"] = "18";
error_dictionary_messages["2"]["18"]["language_id"] = "2";
error_dictionary_messages["2"]["18"]["description"] = "Неправильный spectator_flag";
error_dictionary_messages["2"]["19"] = new Array();
error_dictionary_messages["2"]["19"]["id"] = "19";
error_dictionary_messages["2"]["19"]["error_id"] = "19";
error_dictionary_messages["2"]["19"]["language_id"] = "2";
error_dictionary_messages["2"]["19"]["description"] = "Только создатель игры может менять команды игроков";
error_dictionary_messages["2"]["20"] = new Array();
error_dictionary_messages["2"]["20"]["id"] = "20";
error_dictionary_messages["2"]["20"]["error_id"] = "20";
error_dictionary_messages["2"]["20"]["language_id"] = "2";
error_dictionary_messages["2"]["20"]["description"] = "Нельзя менять команды после начала игры";
error_dictionary_messages["2"]["21"] = new Array();
error_dictionary_messages["2"]["21"]["id"] = "21";
error_dictionary_messages["2"]["21"]["error_id"] = "21";
error_dictionary_messages["2"]["21"]["language_id"] = "2";
error_dictionary_messages["2"]["21"]["description"] = "Этого игрока нет в этой игре";
error_dictionary_messages["2"]["22"] = new Array();
error_dictionary_messages["2"]["22"]["id"] = "22";
error_dictionary_messages["2"]["22"]["error_id"] = "22";
error_dictionary_messages["2"]["22"]["language_id"] = "2";
error_dictionary_messages["2"]["22"]["description"] = "Только создатель игры может удалить игрока";
error_dictionary_messages["2"]["23"] = new Array();
error_dictionary_messages["2"]["23"]["id"] = "23";
error_dictionary_messages["2"]["23"]["error_id"] = "23";
error_dictionary_messages["2"]["23"]["language_id"] = "2";
error_dictionary_messages["2"]["23"]["description"] = "Нельзя удалить игрока после начала игры";
error_dictionary_messages["2"]["24"] = new Array();
error_dictionary_messages["2"]["24"]["id"] = "24";
error_dictionary_messages["2"]["24"]["error_id"] = "24";
error_dictionary_messages["2"]["24"]["language_id"] = "2";
error_dictionary_messages["2"]["24"]["description"] = "Нельзя выйти из общего чата";
error_dictionary_messages["2"]["25"] = new Array();
error_dictionary_messages["2"]["25"]["id"] = "25";
error_dictionary_messages["2"]["25"]["error_id"] = "25";
error_dictionary_messages["2"]["25"]["language_id"] = "2";
error_dictionary_messages["2"]["25"]["description"] = "Неправильная команда";
error_dictionary_messages["2"]["26"] = new Array();
error_dictionary_messages["2"]["26"]["id"] = "26";
error_dictionary_messages["2"]["26"]["error_id"] = "26";
error_dictionary_messages["2"]["26"]["language_id"] = "2";
error_dictionary_messages["2"]["26"]["description"] = "Только создатель игры может начать игру";
error_dictionary_messages["2"]["27"] = new Array();
error_dictionary_messages["2"]["27"]["id"] = "27";
error_dictionary_messages["2"]["27"]["error_id"] = "27";
error_dictionary_messages["2"]["27"]["language_id"] = "2";
error_dictionary_messages["2"]["27"]["description"] = "Игра уже начата";
error_dictionary_messages["2"]["28"] = new Array();
error_dictionary_messages["2"]["28"]["id"] = "28";
error_dictionary_messages["2"]["28"]["error_id"] = "28";
error_dictionary_messages["2"]["28"]["language_id"] = "2";
error_dictionary_messages["2"]["28"]["description"] = "Недопустимое количество игроков";
error_dictionary_messages["2"]["29"] = new Array();
error_dictionary_messages["2"]["29"]["id"] = "29";
error_dictionary_messages["2"]["29"]["error_id"] = "29";
error_dictionary_messages["2"]["29"]["language_id"] = "2";
error_dictionary_messages["2"]["29"]["description"] = "Игра еще не начата";
error_dictionary_messages["2"]["30"] = new Array();
error_dictionary_messages["2"]["30"]["id"] = "30";
error_dictionary_messages["2"]["30"]["error_id"] = "30";
error_dictionary_messages["2"]["30"]["language_id"] = "2";
error_dictionary_messages["2"]["30"]["description"] = "Пользователь уже создал игру в арене";
error_dictionary_messages["2"]["31"] = new Array();
error_dictionary_messages["2"]["31"]["id"] = "31";
error_dictionary_messages["2"]["31"]["error_id"] = "31";
error_dictionary_messages["2"]["31"]["language_id"] = "2";
error_dictionary_messages["2"]["31"]["description"] = "Нельзя выйти из арены, пока вы в игре {0}";
error_dictionary_messages["2"]["32"] = new Array();
error_dictionary_messages["2"]["32"]["id"] = "32";
error_dictionary_messages["2"]["32"]["error_id"] = "32";
error_dictionary_messages["2"]["32"]["language_id"] = "2";
error_dictionary_messages["2"]["32"]["description"] = "Вы уже в этом чате";
error_dictionary_messages["2"]["33"] = new Array();
error_dictionary_messages["2"]["33"]["id"] = "33";
error_dictionary_messages["2"]["33"]["error_id"] = "33";
error_dictionary_messages["2"]["33"]["language_id"] = "2";
error_dictionary_messages["2"]["33"]["description"] = "Недопустимое значение для фичи game_feature_id={0}";
error_dictionary_messages["2"]["34"] = new Array();
error_dictionary_messages["2"]["34"]["id"] = "34";
error_dictionary_messages["2"]["34"]["error_id"] = "34";
error_dictionary_messages["2"]["34"]["language_id"] = "2";
error_dictionary_messages["2"]["34"]["description"] = "Невозможно открыть чат с самим собой";
error_dictionary_messages["2"]["35"] = new Array();
error_dictionary_messages["2"]["35"]["id"] = "35";
error_dictionary_messages["2"]["35"]["error_id"] = "35";
error_dictionary_messages["2"]["35"]["language_id"] = "2";
error_dictionary_messages["2"]["35"]["description"] = "Неизвестный код языка: {0}";

var games_features = new Array();
games_features["1"] = new Array();
games_features["1"]["id"] = "1";
games_features["1"]["code"] = "random_teams";
games_features["1"]["default_param"] = "0";
games_features["1"]["feature_type"] = "bool";
games_features["2"] = new Array();
games_features["2"]["id"] = "2";
games_features["2"]["code"] = "all_versus_all";
games_features["2"]["default_param"] = "0";
games_features["2"]["feature_type"] = "bool";
games_features["3"] = new Array();
games_features["3"]["id"] = "3";
games_features["3"]["code"] = "number_of_teams";
games_features["3"]["default_param"] = "2";
games_features["3"]["feature_type"] = "int";
games_features["4"] = new Array();
games_features["4"]["id"] = "4";
games_features["4"]["code"] = "teammates_in_random_castles";
games_features["4"]["default_param"] = "0";
games_features["4"]["feature_type"] = "bool";

var games_feature_names = new Array();
games_feature_names["1"] = new Array();
games_feature_names["1"]["1"] = new Array();
games_feature_names["1"]["1"]["id"] = "5";
games_feature_names["1"]["1"]["feature_id"] = "1";
games_feature_names["1"]["1"]["language_id"] = "1";
games_feature_names["1"]["1"]["description"] = "Random teams";
games_feature_names["1"]["2"] = new Array();
games_feature_names["1"]["2"]["id"] = "6";
games_feature_names["1"]["2"]["feature_id"] = "2";
games_feature_names["1"]["2"]["language_id"] = "1";
games_feature_names["1"]["2"]["description"] = "No teams (free-for-all)";
games_feature_names["1"]["3"] = new Array();
games_feature_names["1"]["3"]["id"] = "7";
games_feature_names["1"]["3"]["feature_id"] = "3";
games_feature_names["1"]["3"]["language_id"] = "1";
games_feature_names["1"]["3"]["description"] = "Number of teams";
games_feature_names["1"]["4"] = new Array();
games_feature_names["1"]["4"]["id"] = "8";
games_feature_names["1"]["4"]["feature_id"] = "4";
games_feature_names["1"]["4"]["language_id"] = "1";
games_feature_names["1"]["4"]["description"] = "Allies are placed randomly instead of opposite";
games_feature_names["2"] = new Array();
games_feature_names["2"]["1"] = new Array();
games_feature_names["2"]["1"]["id"] = "1";
games_feature_names["2"]["1"]["feature_id"] = "1";
games_feature_names["2"]["1"]["language_id"] = "2";
games_feature_names["2"]["1"]["description"] = "Случайные союзы";
games_feature_names["2"]["2"] = new Array();
games_feature_names["2"]["2"]["id"] = "2";
games_feature_names["2"]["2"]["feature_id"] = "2";
games_feature_names["2"]["2"]["language_id"] = "2";
games_feature_names["2"]["2"]["description"] = "Каждый сам за себя";
games_feature_names["2"]["3"] = new Array();
games_feature_names["2"]["3"]["id"] = "3";
games_feature_names["2"]["3"]["feature_id"] = "3";
games_feature_names["2"]["3"]["language_id"] = "2";
games_feature_names["2"]["3"]["description"] = "Количество команд";
games_feature_names["2"]["4"] = new Array();
games_feature_names["2"]["4"]["id"] = "4";
games_feature_names["2"]["4"]["feature_id"] = "4";
games_feature_names["2"]["4"]["language_id"] = "2";
games_feature_names["2"]["4"]["description"] = "Союзники не напротив, а случайным образом";

var modes = new Array();
modes["9"] = new Array();
modes["9"]["id"] = "9";
modes["9"]["name"] = "Double Turns";
modes["9"]["min_players"] = "2";
modes["9"]["max_players"] = "4";
