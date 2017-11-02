use lords;

DROP TABLE IF EXISTS `error_dictionary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `error_dictionary` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `error_dictionary`
--

LOCK TABLES `error_dictionary` WRITE;
/*!40000 ALTER TABLE `error_dictionary` DISABLE KEYS */;
INSERT INTO `error_dictionary` VALUES 
(1,'not_your_turn'),
(2,'not_enough_gold'),
(3,'no_more_cards'),
(4,'incorrect_sum'),
(5,'subsidy_already_taken'),
(6,'not_enough_castle_hp'),
(7,'already_started_moving_units'),
(8,'no_such_dead_unit'),
(9,'spawn_point_occupued'),
(10,'you_dont_have_this_card'),
(11,'building_outside_zone'),
(12,'place_occupied'),
(13,'invalid_player'),
(14,'unit_not_selected'),
(15,'invalid_card_action'),
(16,'not_own_unit_selected'),
(17,'unit_has_no_more_moves'),
(18,'unit_is_paralyzed'),
(19,'cant_step_on_cell'),
(20,'cant_attack_cell'),
(21,'no_valid_target'),
(22,'player_doesnt_have_cards'),
(23,'target_should_be_inside_board'),
(24,'cant_finish_card_action'),
(25,'invalid_zone'),
(26,'building_not_selected'),
(27,'you_should_select_other_players_building'),
(28,'need_to_finish_card_action'),
(29,'target_out_of_reach'),
(30,'unit_doesnt_have_this_ability'),
(31,'ram_can_be_attached_only_to_another_unit'),
(32,'can_heal_only_other_unit'),
(33,'can_cast_fireball_only_into_other_unit'),
(34,'grave_out_of_reach'),
(35,'vampire_not_in_own_zone'),
(36,'cant_send_money_to_self'),
(37,'sacrifice_not_chosen'),
(38,'can_sacrifice_only_own_unit'),
(39,'sacrifice_target_not_set'),
(40,'sacrifice_target_is_not_unit'),
(41,'unit_cannot_levelup'),
(42,'can_play_card_or_resurrect_only_once_per_turn'),
(43,'moving_this_building_disallowed'),
(44,'not_own_building'),
(45,'building_blocked'),
(46,'building_doesnt_have_this_ability'),
(47,'building_already_moved_this_turn');
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
  PRIMARY KEY (`id`),
  FOREIGN KEY (`error_id`) REFERENCES `error_dictionary` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


INSERT INTO `error_dictionary_i18n` (language_id, error_id, description) VALUES
(2,1,'Не ваш ход'),
(2,2,'Недостаточно золота'),
(2,3,'Карт больше нет'),
(2,4,'Неправильная сумма'),
(2,5,'Вы уже взяли субсидию в этом ходу'),
(2,6,'Недостаточно хитов замка'),
(2,7,'Вы уже начали ходить юнитами'),
(2,8,'Нет такого мертвого юнита'),
(2,9,'Место появления занято'),
(2,10,'У вас нет такой карты'),
(2,11,'Здание выходит за рамки вашей зоны'),
(2,12,'Место занято'),
(2,13,'Нет такого игрока'),
(2,14,'Юнит не выбран'),
(2,15,'Этой картой нельзя этого сделать :-P'),
(2,16,'Выбран чужой юнит'),
(2,17,'У юнита не осталось ходов'),
(2,18,'Юнит парализован'),
(2,19,'На эту клетку нельзя походить'),
(2,20,'Эту клетку нельзя атаковать'),
(2,21,'Здесь нечего атаковать'),
(2,22,'У этого игрока нет карт'),
(2,23,'Цель не может выходить за карту'),
(2,24,'Нельзя доиграть пользу/вред'),
(2,25,'Неправильная зона'),
(2,26,'Здание не выбрано'),
(2,27,'Нужно выбрать чужое здание'),
(2,28,'Нужно доиграть пользу/вред'),
(2,29,'Цель вне досягаемости'),
(2,30,'Юнит это не умеет :-P'),
(2,31,'Можно прицепить таран только к другому юниту'),
(2,32,'Можно лечить только другого юнита'),
(2,33,'Можно пустить огненный шар только в другого юнита'),
(2,34,'Могила вне досягаемости'),
(2,35,'Можно призвать вампира только в своей зоне'),
(2,36,'Вы хотите отправить деньги себе. Они уже тут'),
(2,37,'Жертва не выбрана'),
(2,38,'Можно принести в жертву только своего юнита'),
(2,39,'Цель для жертвоприношения не выбрана'),
(2,40,'Нужно выбрать юнита в качестве цели'),
(2,41,'Юнит не может перейти на следующий уровень'),
(2,42,'Сыграть карту либо воскресить юнита можно только один раз за ход'),
(2,43,'Извините, создатель мода не хотел, чтобы вы перемещали это здание'),
(2,44,'Это не ваше здание'),
(2,45,'Здание заблокировано'),
(2,46,'Здание это не умеет :-P'),
(2,47,'Здание уже действовало в этот ход');

INSERT INTO `error_dictionary_i18n` (language_id, error_id, description) VALUES
(1,1,'Not your turn'),
(1,2,'Not enough gold'),
(1,3,'No more cards'),
(1,4,'Invalid sum'),
(1,5,'You can sell rocks only once per turn'),
(1,6,'Not enough castle health points'),
(1,7,'You already started moving units'),
(1,8,'No such dead unit'),
(1,9,'Spawn point occupied'),
(1,10,'You don''t have this card'),
(1,11,'Building should be completely in your zone'),
(1,12,'Place is occupied'),
(1,13,'Invalid player'),
(1,14,'Unit is not selected'),
(1,15,'This card cannot do this :-P'),
(1,16,'You need to select your own unit'),
(1,17,'Unit has no more moves'),
(1,18,'Unit is paralyzed'),
(1,19,'Destination out of reach'),
(1,20,'Attack destination out of reach'),
(1,21,'Nothing to attack here'),
(1,22,'This player has no cards'),
(1,23,'Target should be on the board completely'),
(1,24,'Invalid card action'),
(1,25,'Invalid zone'),
(1,26,'Building is not chosen'),
(1,27,'You need to choose someone else''s building'),
(1,28,'You need to finish card action'),
(1,29,'Target out of reach'),
(1,30,'This unit cannot do this :-P'),
(1,31,'You can only attach ram to another unit'),
(1,32,'You can only heal another unit'),
(1,33,'You can only cast fireball into another unit'),
(1,34,'Grave out of reach'),
(1,35,'You can only summon a vampire in your own zone'),
(1,36,'You want to send money to yourself. It is already here'),
(1,37,'Please choose someone to sacrifice'),
(1,38,'You can sacrifice only your own unit'),
(1,39,'Sacrifice target not chosen'),
(1,40,'Sacrifice target should be another unit'),
(1,41,'Unit cannot levelup'),
(1,42,'You can play a card or resurrect only once per turn'),
(1,43,'Sorry, the author of the mode didn''t want you to move this'),
(1,44,'This is not your building'),
(1,45,'Building is blocked'),
(1,46,'This building cannot do it :-P'),
(1,47,'A building can act only once per turn');



delimiter $$
DROP PROCEDURE IF EXISTS `cast_polza_move_building`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_polza_move_building`(g_id INT,p_num INT,b_x INT,b_y INT,x INT,y INT,rot INT,flp INT)
BEGIN
  DECLARE nonfinished_action INT DEFAULT 3;
  DECLARE board_building_id INT;
  DECLARE p2_num INT;
  DECLARE building_id INT;
  DECLARE building_name VARCHAR(45) CHARSET utf8;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    IF NOT nonfinished_action=(SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=24;
    ELSE
      SELECT b.ref INTO board_building_id FROM board b WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND b.x=b_x AND b.y=b_y LIMIT 1;
      IF board_building_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=26;
      ELSE
        SELECT bb.player_num INTO p2_num FROM board_buildings bb WHERE bb.id=board_building_id LIMIT 1;
        IF p2_num=p_num THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=27;
        ELSE
          IF building_feature_check(board_building_id,'not_movable')=1 THEN
            SELECT bb.building_id INTO building_id FROM board_buildings bb WHERE bb.id=board_building_id;
            SELECT b.name INTO building_name FROM buildings b WHERE b.id=building_id;
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=43;
          ELSE
            CALL user_action_begin();

            
            UPDATE board SET ref=0 WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=board_building_id;

            CALL place_building_on_board(board_building_id,x,y,rot,flp);

            IF NOT EXISTS(SELECT id FROM board WHERE game_id=g_id AND `type`<>'unit' AND ref=board_building_id) THEN 
              UPDATE board SET ref=board_building_id WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0;
              SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;
            ELSE
            
              DELETE FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0; 

              UPDATE board_buildings SET player_num=p_num,rotation=rot,flip=flp WHERE id=board_building_id;

              CALL count_income(board_building_id);

              CALL cmd_move_building(g_id,p_num,b_x,b_y,board_building_id);
              CALL cmd_building_set_owner(g_id,p_num,board_building_id);


              UPDATE command SET hidden_flag=1 WHERE game_id=g_id AND player_num=p_num AND hidden_flag=2;
              UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

              CALL finish_playing_card(g_id,p_num);
              CALL end_cards_phase(g_id,p_num);

              CALL user_action_end();
            END IF;
          END IF;
        END IF;
      END IF;
    END IF;
  END IF;

END$$

DELIMITER ;

