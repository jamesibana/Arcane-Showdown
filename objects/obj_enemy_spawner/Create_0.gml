
spawn_pool = [
    { obj: obj_enemy_minion, weight: 33 },
    { obj: obj_enemy_slime, weight: 33 },
    { obj: obj_enemy_golem, weight: 16 },
    { obj: obj_enemy_serpent, weight: 16 },
    { obj: obj_enemy_obelisk, weight: 6 },
    { obj: obj_enemy_sword_master, weight: 6 }
];

array_push(global.spawner_list, id);

// create list if it doesn't exist
if (!variable_global_exists("spawner_list")) {
    global.spawner_list = [];
}

// add this spawner to list
array_push(global.spawner_list, id);