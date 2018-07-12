use lords;

UPDATE attack_bonus
  SET dice_max = 12, critical_chance = 12 WHERE dice_max = 6 AND critical_chance = 6;

UPDATE attack_bonus
  SET dice_max = 6, critical_chance = 6 WHERE dice_max = 3 AND critical_chance = 3;

DELETE FROM attack_bonus where unit_id not in
  (select unit_id from units_procedures up join procedures p on up.procedure_id = p.id where p.name = 'attack');

