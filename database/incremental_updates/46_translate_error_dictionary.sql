use lords_site;

DROP TABLE IF EXISTS `error_dictionary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `error_dictionary` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `error_dictionary`
--

LOCK TABLES `error_dictionary` WRITE;
/*!40000 ALTER TABLE `error_dictionary` DISABLE KEYS */;
INSERT INTO `error_dictionary` VALUES
(1,'login_exists'),
(2,'empty_login_or_pass'),
(3,'incorrect_login_or_pass'),
(4,'incorrect_user_id'),
(5,'incorrect_chat_id'),
(6,'not_in_chat'),
(7,'cant_change_common_chat_topic'),
(8,'not_in_arena'),
(9,'time_limit_not_positive'),
(10,'incorrect_mode'),
(11,'no_right_to_modify_game_features'),
(12,'incorrect_feature_for_game'),
(13,'incorrect_game_pass'),
(14,'in_another_game'),
(15,'cant_modify_game_features_after_start'),
(16,'incorrect_game'),
(17,'cant_enter_game_after_start'),
(18,'incorrect_spectator_flag'),
(19,'no_right_to_modify_teams'),
(20,'cant_modify_teams_after_start'),
(21,'player_not_in_game'),
(22,'no_right_to_remove_player'),
(23,'cant_remove_player_after_start'),
(24,'cant_leave_common_chat'),
(25,'incorrect_team'),
(26,'no_right_to_start_game'),
(27,'game_already_started'),
(28,'incorrect_number_of_players'),
(29,'game_not_started'),
(30,'already_created_another_game'),
(31,'cant_exit_arena_while_in_game'),
(32,'already_in_chat'),
(33,'incorrect_game_feature_value'),
(34,'self_chat'),
(35,'incorrect_language_code');
/*!40000 ALTER TABLE `error_dictionary` ENABLE KEYS */;
UNLOCK TABLES;


DROP TABLE IF EXISTS `error_dictionary_i18n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `error_dictionary_i18n` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `error_id` int(10) unsigned NOT NULL,
  `language_id` int(10) unsigned NOT NULL,
  `description` varchar(200) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

INSERT INTO `error_dictionary_i18n` (language_id, error_id, description) VALUES
(2,1,'Логин {0} существует'),
(2,2,'Пустой логин или пароль'),
(2,3,'Неверный логин или пароль'),
(2,4,'Неправильный user_id'),
(2,5,'Неправильный chat_id'),
(2,6,'Вас нет в этом чате'),
(2,7,'Нельзя изменить тему общего чата'),
(2,8,'Вас нет в арене'),
(2,9,'Ограничение по времени должно быть положительным'),
(2,10,'Нет такого мода'),
(2,11,'Только создатель игры может добавлять и удалять фичи'),
(2,12,'Для этой игры нет такой фичи'),
(2,13,'Неправильный пароль к игре'),
(2,14,'Вы уже находитесь в другой игре'),
(2,15,'Нельзя добавлять и удалять фичи после начала игры'),
(2,16,'Нет такой игры'),
(2,17,'Нельзя войти в игру после начала игры'),
(2,18,'Неправильный spectator_flag'),
(2,19,'Только создатель игры может менять команды игроков'),
(2,20,'Нельзя менять команды после начала игры'),
(2,21,'Этого игрока нет в этой игре'),
(2,22,'Только создатель игры может удалить игрока'),
(2,23,'Нельзя удалить игрока после начала игры'),
(2,24,'Нельзя выйти из общего чата'),
(2,25,'Неправильная команда'),
(2,26,'Только создатель игры может начать игру'),
(2,27,'Игра уже начата'),
(2,28,'Недопустимое количество игроков'),
(2,29,'Игра еще не начата'),
(2,30,'Пользователь уже создал игру в арене'),
(2,31,'Нельзя выйти из арены, пока вы в игре {0}'),
(2,32,'Вы уже в этом чате'),
(2,33,'Недопустимое значение для фичи game_feature_id={0}'),
(2,34,'Невозможно открыть чат с самим собой'),
(2,35,'Неизвестный код языка: {0}');

INSERT INTO `error_dictionary_i18n` (language_id, error_id, description) VALUES
(1,1,'Login {0} already exists'),
(1,2,'Blank login or password'),
(1,3,'Incorrect login or password'),
(1,4,'Incorrect user_id'),
(1,5,'Incorrect chat_id'),
(1,6,'You are not in this chat'),
(1,7,'You cannot change the topic of the common chat'),
(1,8,'You are not in the Arena'),
(1,9,'Time restriction should be positive'),
(1,10,'Mode does not exist'),
(1,11,'Only game creator can add or remove game features'),
(1,12,'There is no such game feachure for this game'),
(1,13,'Incorrect game password'),
(1,14,'You are already in another game'),
(1,15,'You cannot add or remove game features after the game has started'),
(1,16,'Game does not exist'),
(1,17,'You cannot enter the game after its start'),
(1,18,'Incorrect spectator_flag'),
(1,19,'Only game creator can modify teams'),
(1,20,'You cannot modify teams after the game has started'),
(1,21,'This player is not in this game'),
(1,22,'Only game creator can remove a player'),
(1,23,'You cannot remove a player after the game has started'),
(1,24,'You cannot leave the common chat'),
(1,25,'Incorrect team'),
(1,26,'Only game creator can start the game'),
(1,27,'The game is already started'),
(1,28,'Incorrect number of players'),
(1,29,'The game is not started yet'),
(1,30,'The user has already started a game in Arena'),
(1,31,'You cannot leave Arena while you are in game {0}'),
(1,32,'You are already in this chat'),
(1,33,'Incorrect value for game feature game_feature_id={0}'),
(1,34,'You cannot open a chat with yourself'),
(1,35,'Unknown language code: {0}');

