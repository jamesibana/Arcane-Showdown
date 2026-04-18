
spawn_pool = [
    { obj: obj_enemy_minion, weight: 26 },
    { obj: obj_enemy_slime, weight: 26 },
    { obj: obj_enemy_golem, weight: 16 },
    { obj: obj_enemy_serpent, weight: 16 },
    { obj: obj_enemy_obelisk, weight: 8 },
    { obj: obj_enemy_swordmaster, weight: 8 }
];

// create list if it doesn't exist
if (!variable_global_exists("spawner_list")) {
    global.spawner_list = [];
}

// add this spawner to list
array_push(global.spawner_list, id);