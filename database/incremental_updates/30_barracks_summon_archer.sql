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