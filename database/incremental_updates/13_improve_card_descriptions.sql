use lords;

update cards_i18n set description = 'Дает выбранному юниту магический щит, который единоразово защищает от любого физического или магического урона.' where description = '+1 щит любому юниту.';
update cards_i18n set description = 'Повергает выбранного юнита в бешенство, он начинает атаковать ближайших юнитов.' where description = 'Повергает выбранного юнита в бешенство.';
update cards_i18n set description = 'Починка всех своих зданий включая Замок.' where description = 'Починка всех своих здания включая Замок.';
update cards_i18n set description = 'Causes either 2 damage (weak lightning) or 3 damage with probability 2/3 (strong lightning) to units' where description = 'Causes 2 damage to units (weak lightning) or 3 damage with probability 2/3 (strong lightning)';
update cards_i18n set description = 'Move any unit to any free cell' where description = 'Move any unit to any free square';
update cards_i18n set description = 'Causes 2 damage to units and buildings (except castles) in area 2 by 2' where description = 'Causes 2 damage to units and buildings (except castles) in area 2 x 2 squares';
update cards_i18n set description = 'Gives the chosen unit a magical shield, a one-time protection from any physical or magical damage' where description = 'Give a magical shield to any unit';
update cards_i18n set description = 'Gives control over the chosen unit' where description = 'Gives control over a chosen unit';
update cards_i18n set description = 'Makes the chosen unit mad. Mad unit will attack the closest units' where description = 'Makes a chosen unit mad. Mad units move to and attack the closest unit';
update cards_i18n set description = 'Steal a random card from the chosen player' where description = 'Steal a random card from a chosen player';
update cards_i18n set description = '-50 gold to the chosen player' where description = '-50 gold to a chosen player';
update cards_i18n set description = 'Summon a vampire in your zone. It is an NPC unit that attacks closest units and buildings of all players' where description = 'Summon a vampire in your zone. Vampire attacks closest units and buildings';
update cards_i18n set description = '+2 movement points to the chosen unit' where description = '+2 movement points to any unit';
update cards_i18n set description = 'Either +1 attack, +1 move, +1 health to the chosen unit (uniform enhancement) or +3 to a random parameter (random enhancement)' where description = 'Either +1 attack, +1 move, +1 health to a chosen unit (uniform enhancement) or +3 to a random parameter (random enhancement)';
update cards_i18n set description = '+2 health to the chosen unit' where description = '+2 health to any unit';
update cards_i18n set description = '+2 attack to the chosen unit' where description = '+2 attack to any unit';
update cards_i18n set description = '4 damage to the chosen building (except castles)' where description = '4 damage to any building (except castles)';
update cards_i18n set description = 'Move the chosen building or obstacle (except castles) anywhere on the board' where description = 'Move chosen building or obstacle (except castles) anywhere else';
update cards_i18n set description = 'Move all units either into or out of the chosen zone' where description = 'Move all units either into or out of a chosen zone';
update cards_i18n set description = 'Creates a 5x5 square of trees around the chosen cell' where description = 'Creates a 5x5 square of trees around a chosen cell';
update cards_i18n set description = 'Summon an NPC bandit in your zone. Every turn he will fight for whoever gives more money' where description = 'Summon an NPC bandit in your zone. He will fight for whoever gives more money every turn';

update buildings_i18n set description = 'Spawns 3 NPC frogs that attack the closest units of all players, may spawn more later' where description = 'Spawns 3 agessive frogs, may spawn more later';
update buildings_i18n set description = 'Spawns an NPC Troll that attacks the closest buildings of all players (except castles), may spawn more later' where description = 'Spawns a troll that wants to destroy buildings, may spawn more later';
update buildings_i18n set description = 'Spawns allied NPC Spearman and Archer that attack closest units and buildings of the opponents, may spawn more later' where description = 'Spawns allied NPC Spearman and Archer, may spawn more later';

