use lords;

insert into summon_cfg(building_id, unit_id, count, owner, mode_id)
  values(
    (select id from buildings where ui_code = 'barracks' limit 1),
    (select id from units where ui_code = 'archer' limit 1),
    1,
    4,
    9
  );

update summon_cfg set count = 1
  where building_id = (select id from buildings where ui_code = 'barracks' limit 1)
    and unit_id = (select id from units where ui_code = 'spearman' limit 1);

update buildings_i18n set description = 'Spawns allied NPC Spearman and Archer, may spawn more later'
where language_id = 1 and building_id = (select id from buildings where ui_code = 'barracks' limit 1);

update buildings_i18n set description = 'Появляются союзные NPC копейщик и лучник. Потом иногда появляются еще копейщики или лучники.'
where language_id = 2 and building_id = (select id from buildings where ui_code = 'barracks' limit 1);
