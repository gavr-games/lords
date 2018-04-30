use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`get_game_statistic` $$

CREATE PROCEDURE `get_game_statistic`(g_id INT)
BEGIN

  SELECT
    t.id as `tab_id`,
    t.name as `tab_name`,
    c.id as `chart_id`,
    c.type as `chart_type`,
    c.name as `chart_name`,
    v.id as `value_id`,
    v.value,
    CASE vc.color
      WHEN 'card_color' THEN
        CASE (SELECT type FROM cards WHERE id = v.value)
          WHEN 'u' THEN 'unit'
          WHEN 'b' THEN 'building'
          WHEN 'm' THEN 'magic'
		END
      ELSE vc.color
	END as color,
    v.name as `value_name`,
    p.player_name
  FROM
    statistic_tabs t
    JOIN statistic_charts c ON (c.tab_id = t.id)
    JOIN statistic_values_config vc ON (vc.chart_id = c.id)
    JOIN statistic_values v ON (v.stat_value_config_id = vc.id)
    JOIN statistic_players p ON (p.player_num = vc.player_num)
  WHERE v.game_id = g_id AND p.game_id = g_id
  ORDER BY `tab_id`,`chart_id`,`value_id`;

END$$

DELIMITER ;

