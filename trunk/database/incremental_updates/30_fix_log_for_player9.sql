use lords;

DELIMITER $$

DROP FUNCTION IF EXISTS `lords`.`log_building` $$
CREATE DEFINER=`root`@`localhost` FUNCTION `log_building`(board_building_id INT) RETURNS varchar(200) CHARSET utf8
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE b_id INT;
  DECLARE player_class VARCHAR(45);

  SELECT game_id,player_num,building_id INTO g_id,p_num,b_id FROM board_buildings WHERE id=board_building_id LIMIT 1;

  IF EXISTS(SELECT id FROM players WHERE game_id=g_id AND player_num=p_num)THEN
    SELECT CASE WHEN p.owner=1 THEN CONCAT('p',p.player_num) ELSE 'newtrl' END INTO player_class FROM players p WHERE p.game_id=g_id AND p.player_num=p_num LIMIT 1;
  ELSE
    SET player_class='newtrl';
  END IF;

  RETURN CONCAT('<b class=\'',player_class,'\' title=\'highlight_building(',board_building_id,')|unhighlight_building(',board_building_id,')\'>',(SELECT log_short_name FROM buildings WHERE id=b_id LIMIT 1),'</b>');

END $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `lords`.`log_unit` $$
CREATE DEFINER=`root`@`localhost` FUNCTION `log_unit`(board_unit_id INT) RETURNS varchar(200) CHARSET utf8
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE u_id INT;
  DECLARE player_class VARCHAR(45);

  SELECT game_id,player_num,unit_id INTO g_id,p_num,u_id FROM board_units WHERE id=board_unit_id LIMIT 1;

  IF EXISTS(SELECT id FROM players WHERE game_id=g_id AND player_num=p_num)THEN
    SELECT CASE WHEN p.owner=1 THEN CONCAT('p',p.player_num) ELSE 'newtrl' END INTO player_class FROM players p WHERE p.game_id=g_id AND p.player_num=p_num LIMIT 1;
  ELSE
    SET player_class='newtrl';
  END IF;

  RETURN CONCAT('<b class=\'',player_class,'\' title=\'highlight_unit(',board_unit_id,')|unhighlight_unit(',board_unit_id,')\'>',(SELECT log_short_name FROM units WHERE id=u_id LIMIT 1),'</b>');

END $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `lords`.`log_unit_rod_pad` $$
CREATE DEFINER=`root`@`localhost` FUNCTION `log_unit_rod_pad`(board_unit_id INT) RETURNS varchar(200) CHARSET utf8
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE u_id INT;
  DECLARE player_class VARCHAR(45);

  SELECT game_id,player_num,unit_id INTO g_id,p_num,u_id FROM board_units WHERE id=board_unit_id LIMIT 1;

  IF EXISTS(SELECT id FROM players WHERE game_id=g_id AND player_num=p_num)THEN
    SELECT CASE WHEN p.owner=1 THEN CONCAT('p',p.player_num) ELSE 'newtrl' END INTO player_class FROM players p WHERE p.game_id=g_id AND p.player_num=p_num LIMIT 1;
  ELSE
    SET player_class='newtrl';
  END IF;

  RETURN CONCAT('<b class=\'',player_class,'\' title=\'highlight_unit(',board_unit_id,')|unhighlight_unit(',board_unit_id,')\'>',(SELECT log_name_rod_pad FROM units WHERE id=u_id LIMIT 1),'</b>');

END $$

DELIMITER ;
