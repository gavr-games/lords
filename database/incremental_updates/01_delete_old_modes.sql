use lords;

USE `lords`;
DROP procedure IF EXISTS `mode_delete`;

DELIMITER $$
USE `lords`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mode_delete`(mode_id INT, delete_not_used_cards_units_buildings INT)
BEGIN
  DELETE FROM modes WHERE id=mode_id;

  IF(delete_not_used_cards_units_buildings = 1)THEN
    DELETE FROM cards WHERE id NOT IN (SELECT card_id FROM modes_cards);
    
    CREATE TEMPORARY TABLE tmp_buildings_to_delete (id INT);
    CREATE TEMPORARY TABLE tmp_units_to_delete (id INT);

    INSERT INTO tmp_buildings_to_delete (id)
      SELECT id FROM buildings WHERE id NOT IN (SELECT id FROM vw_mode_buildings);

    INSERT INTO tmp_units_to_delete (id)
      SELECT id FROM units WHERE id NOT IN (SELECT id FROM vw_mode_units);

    DELETE FROM buildings WHERE id IN (SELECT id FROM tmp_buildings_to_delete);
    DELETE FROM units WHERE id IN (SELECT id FROM tmp_units_to_delete);

    DROP TEMPORARY TABLE tmp_buildings_to_delete;
    DROP TEMPORARY TABLE tmp_units_to_delete;

  END IF;

END$$

DELIMITER ;


call mode_delete(1,1); # bye bye lords classic
call mode_delete(8,1); # steam pack

