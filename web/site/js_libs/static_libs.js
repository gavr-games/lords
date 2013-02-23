var dic_game_types = new Array();dic_game_types[1] = new Array();dic_game_types[1]["id"] = "1";dic_game_types[1]["description"] = "arena";dic_game_types[2] = new Array();dic_game_types[2]["id"] = "2";dic_game_types[2]["description"] = "league";dic_game_types[3] = new Array();dic_game_types[3]["id"] = "3";dic_game_types[3]["description"] = "campaign";var dic_player_status = new Array();dic_player_status[1] = new Array();dic_player_status[1]["id"] = "1";dic_player_status[1]["description"] = "Онлайн";dic_player_status[2] = new Array();dic_player_status[2]["id"] = "2";dic_player_status[2]["description"] = "Ждет старта игры";dic_player_status[3] = new Array();dic_player_status[3]["id"] = "3";dic_player_status[3]["description"] = "В игре";dic_player_status[4] = new Array();dic_player_status[4]["id"] = "4";dic_player_status[4]["description"] = "Оффлайн";var error_dictionary = new Array();error_dictionary[1] = new Array();error_dictionary[1]["id"] = "1";error_dictionary[1]["description"] = "Логин {0} существует";error_dictionary[2] = new Array();error_dictionary[2]["id"] = "2";error_dictionary[2]["description"] = "Пустой логин или пароль";error_dictionary[3] = new Array();error_dictionary[3]["id"] = "3";error_dictionary[3]["description"] = "Неверный логин или пароль";error_dictionary[4] = new Array();error_dictionary[4]["id"] = "4";error_dictionary[4]["description"] = "Неправильный user_id";error_dictionary[5] = new Array();error_dictionary[5]["id"] = "5";error_dictionary[5]["description"] = "Неправильный chat_id";error_dictionary[6] = new Array();error_dictionary[6]["id"] = "6";error_dictionary[6]["description"] = "Вас нет в этом чате";error_dictionary[7] = new Array();error_dictionary[7]["id"] = "7";error_dictionary[7]["description"] = "Нельзя изменить тему общего чата";error_dictionary[8] = new Array();error_dictionary[8]["id"] = "8";error_dictionary[8]["description"] = "Вас нет в арене";error_dictionary[9] = new Array();error_dictionary[9]["id"] = "9";error_dictionary[9]["description"] = "Ограничение по времени должно быть положительным";error_dictionary[10] = new Array();error_dictionary[10]["id"] = "10";error_dictionary[10]["description"] = "Нет такого мода";error_dictionary[11] = new Array();error_dictionary[11]["id"] = "11";error_dictionary[11]["description"] = "Только создатель игры может добавлять и удалять фичи";error_dictionary[12] = new Array();error_dictionary[12]["id"] = "12";error_dictionary[12]["description"] = "Для этой игры нет такой фичи";error_dictionary[13] = new Array();error_dictionary[13]["id"] = "13";error_dictionary[13]["description"] = "Неправильный пароль к игре";error_dictionary[14] = new Array();error_dictionary[14]["id"] = "14";error_dictionary[14]["description"] = "Вы уже находитесь в другой игре";error_dictionary[15] = new Array();error_dictionary[15]["id"] = "15";error_dictionary[15]["description"] = "Нельзя добавлять и удалять фичи после начала игры";error_dictionary[16] = new Array();error_dictionary[16]["id"] = "16";error_dictionary[16]["description"] = "Нет такой игры";error_dictionary[17] = new Array();error_dictionary[17]["id"] = "17";error_dictionary[17]["description"] = "Нельзя войти в игру после начала игры";error_dictionary[18] = new Array();error_dictionary[18]["id"] = "18";error_dictionary[18]["description"] = "Неправильный spectator_flag";error_dictionary[19] = new Array();error_dictionary[19]["id"] = "19";error_dictionary[19]["description"] = "Только создатель игры может менять команды игроков";error_dictionary[20] = new Array();error_dictionary[20]["id"] = "20";error_dictionary[20]["description"] = "Нельзя менять команды после начала игры";error_dictionary[21] = new Array();error_dictionary[21]["id"] = "21";error_dictionary[21]["description"] = "Этого игрока нет в этой игре";error_dictionary[22] = new Array();error_dictionary[22]["id"] = "22";error_dictionary[22]["description"] = "Только создатель игры может удалить игрока";error_dictionary[23] = new Array();error_dictionary[23]["id"] = "23";error_dictionary[23]["description"] = "Нельзя удалить игрока после начала игры";error_dictionary[24] = new Array();error_dictionary[24]["id"] = "24";error_dictionary[24]["description"] = "Нельзя выйти из общего чата";error_dictionary[25] = new Array();error_dictionary[25]["id"] = "25";error_dictionary[25]["description"] = "Неправильная команда";error_dictionary[26] = new Array();error_dictionary[26]["id"] = "26";error_dictionary[26]["description"] = "Только создатель игры может начать игру";error_dictionary[27] = new Array();error_dictionary[27]["id"] = "27";error_dictionary[27]["description"] = "Игра уже начата";error_dictionary[28] = new Array();error_dictionary[28]["id"] = "28";error_dictionary[28]["description"] = "Недопустимое количество игроков";error_dictionary[29] = new Array();error_dictionary[29]["id"] = "29";error_dictionary[29]["description"] = "Игра еще не начата";error_dictionary[30] = new Array();error_dictionary[30]["id"] = "30";error_dictionary[30]["description"] = "Пользователь уже создал игру в арене";error_dictionary[31] = new Array();error_dictionary[31]["id"] = "31";error_dictionary[31]["description"] = "Нельзя выйти из арены, пока вы в игре {0}";error_dictionary[32] = new Array();error_dictionary[32]["id"] = "32";error_dictionary[32]["description"] = "Вы уже в этом чате";error_dictionary[33] = new Array();error_dictionary[33]["id"] = "33";error_dictionary[33]["description"] = "Недопустимое значение для фичи game_feature_id={0}";error_dictionary[34] = new Array();error_dictionary[34]["id"] = "34";error_dictionary[34]["description"] = "Невозможно открыть чат с самим собой";var games_features = new Array();games_features[1] = new Array();games_features[1]["id"] = "1";games_features[1]["code"] = "random_teams";games_features[1]["name"] = "Случайные союзы";games_features[1]["default_param"] = "0";games_features[1]["feature_type"] = "bool";games_features[2] = new Array();games_features[2]["id"] = "2";games_features[2]["code"] = "all_versus_all";games_features[2]["name"] = "Каждый сам за себя";games_features[2]["default_param"] = "0";games_features[2]["feature_type"] = "bool";games_features[3] = new Array();games_features[3]["id"] = "3";games_features[3]["code"] = "number_of_teams";games_features[3]["name"] = "Количество команд";games_features[3]["default_param"] = "2";games_features[3]["feature_type"] = "int";games_features[4] = new Array();games_features[4]["id"] = "4";games_features[4]["code"] = "teammates_in_random_castles";games_features[4]["name"] = "Союзники не напротив, а случайным образом";games_features[4]["default_param"] = "0";games_features[4]["feature_type"] = "bool";var modes = new Array();modes[1] = new Array();modes[1]["id"] = "1";modes[1]["name"] = "Lords Classic";modes[1]["min_players"] = "2";modes[1]["max_players"] = "4";modes[8] = new Array();modes[8]["id"] = "8";modes[8]["name"] = "Lords Steam Pack";modes[8]["min_players"] = "2";modes[8]["max_players"] = "4";var dic_game_status = new Array();dic_game_status[1] = new Array();dic_game_status[1]["id"] = "1";dic_game_status[1]["description"] = "created";dic_game_status[2] = new Array();dic_game_status[2]["id"] = "2";dic_game_status[2]["description"] = "started";dic_game_status[3] = new Array();dic_game_status[3]["id"] = "3";dic_game_status[3]["description"] = "finished";