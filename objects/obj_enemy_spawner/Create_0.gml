
spawn_pool = [
    { obj: obj_enemy_minion, weight: 33 },
    { obj: obj_enemy_slime, weight: 33 },
    { obj: obj_enemy_golem, weight: 14 },
    { obj: obj_enemy_serpent, weight: 14 },
    { obj: obj_enemy_obelisk, weight: 3 },
    { obj: obj_enemy_swordmaster, weight: 3 }
];

array_push(global.spawner_list, id);

// create list if it doesn't exist
if (!variable_global_exists("spawner_list")) {
    global.spawner_list = [];
}

// add this spawner to list
array_push(global.spawner_list, id);