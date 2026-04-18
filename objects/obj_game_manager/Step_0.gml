show_debug_message("weapon_data: " + string(global.weapon_data));

/**
// =====================
// ENEMY SPAWN SYSTEM (KILL-BASED)
// =====================
while (global.enemy_kills >= global.kills_to_spawn) {

    global.enemy_kills -= global.kills_to_spawn;

    // pick random spawner
    var rand_index = irandom(array_length(global.spawner_list) - 1);
    var chosen_spawner = global.spawner_list[rand_index];

    with (chosen_spawner) {

        // weighted enemy selection
        var total = 0;

        for (var i = 0; i < array_length(spawn_pool); i++) {
            total += spawn_pool[i].weight;
        }

        var roll = irandom(total - 1);
        var running = 0;

        var chosen_enemy = obj_enemy_minion;

        for (var i = 0; i < array_length(spawn_pool); i++) {
            running += spawn_pool[i].weight;

            if (roll < running) {
                chosen_enemy = spawn_pool[i].obj;
                break;
            }
        }

        instance_create_layer(x, y, "Instances", chosen_enemy);
    }

    show_debug_message("SPAWN TRIGGERED");
}
 **/
//DEBUG
if (keyboard_check_pressed(ord("K"))) {
    global.enemy_kills += 1;
    show_debug_message("KILL +1 → " + string(global.enemy_kills));
}

if (keyboard_check_pressed(ord("P"))) {
    instance_create_layer(x + 64, y, "Instances", obj_enemy_minion);
}


/**
if (keyboard_check_pressed(ord("1"))) {

    if (is_struct(global.weapon_data) && variable_struct_exists(global.weapon_data, "melee")) {

        var drop = instance_create_layer(x + 64, y, "Instances", obj_weapon_pickup);

        with (drop) {
            weapon_key = "melee";
        }

    } else {
        show_debug_message("weapon_data OR melee missing");
    }
}
**/