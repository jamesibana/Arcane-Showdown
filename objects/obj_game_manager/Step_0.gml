// =====================================================
// 0. SAFETY (OPTIONAL BUT GOOD PRACTICE)
// =====================================================
if (!variable_global_exists("initial_spawn_done")) global.initial_spawn_done = false;
if (!variable_global_exists("enemy_kills")) global.enemy_kills = 0;
if (!variable_global_exists("kills_to_spawn")) global.kills_to_spawn = 5;

if (!variable_global_exists("time_spawn_timer")) global.time_spawn_timer = room_speed * 5;
if (!variable_global_exists("time_spawn_interval")) global.time_spawn_interval = room_speed * 5;

if (!variable_global_exists("hitpause")) global.hitpause = 0;


// =====================================================
// 1. INITIAL ROOM SPAWN (WAIT FOR SPAWNERS)
// =====================================================
if (!global.initial_spawn_done) {

    if (array_length(global.spawner_list) == 0) exit;

    for (var s = 0; s < array_length(global.spawner_list); s++) {

        var sp = global.spawner_list[s];

        with (sp) {
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
    }

    global.initial_spawn_done = true;
}


// =====================================================
// 2. KILL-BASED SPAWNING
// =====================================================
while (global.enemy_kills >= global.kills_to_spawn) {

    // prevent infinite stacking
    if (instance_number(obj_enemy_parent) > 30) break;

    global.enemy_kills -= global.kills_to_spawn;

    if (array_length(global.spawner_list) == 0) break;

    var rand_index = irandom(array_length(global.spawner_list) - 1);
    var chosen_spawner = global.spawner_list[rand_index];

    with (chosen_spawner) {
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
}


// =====================================================
// 3. TIME-BASED SPAWNING
// =====================================================
if (array_length(global.spawner_list) > 0) {

    global.time_spawn_timer--;

    if (global.time_spawn_timer <= 0) {

        // prevent overcrowding (DOES NOT break entire step)
        if (instance_number(obj_enemy_parent) <= 30) {
            var rand_index = irandom(array_length(global.spawner_list) - 1);
            var chosen_spawner = global.spawner_list[rand_index];

            with (chosen_spawner) {
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
        }

        // difficulty scaling (IMPORTANT)
        global.time_spawn_interval = max(room_speed * 3, global.time_spawn_interval - 8);

        // reset timer
        global.time_spawn_timer = global.time_spawn_interval;
    }
}


// =====================================================
// 4. HIT PAUSE SYSTEM
// =====================================================
if (global.hitpause > 0) {
    global.hitpause--;
}


// =====================================================
// 5. ARENA-ONLY LOGIC BARRIER
// =====================================================
// EVERYTHING below this line will ONLY run if we are in the arena!
if (room != rm_arena) exit;


// =====================================================
// 6. FIND PLAYERS (WITH STRING-TO-NUMBER FIX)
// =====================================================
var p1_exists = false;
var p2_exists = false;

with (obj_player1) {
    
    // Safety check in case they are still initializing
    if (!variable_instance_exists(id, "owner_player")) continue; 

    // Force the ID to be a number, and state to be lowercase
    var my_id = real(owner_player); 
    var my_state = string_lower(string(state));

    // Notice: No "other." used here!
    if (my_id == 1 && my_state != "dead") p1_exists = true;
    if (my_id == 2 && my_state != "dead") p2_exists = true;
}


// =====================================================
// 7. WIN LOGIC
// =====================================================
if (!global.round_over) {

    // A. ROUND ACTIVATION
    if (!global.round_active) {
        if (p1_exists && p2_exists) {
            global.round_active = true;
            show_debug_message("ROUND STARTED - FIGHT!"); 
        }
    } 
    // B. MONITOR FOR WINNER
    else {
        if (p1_exists && !p2_exists) {
            global.p1_wins += 1;
            global.round_over = true;
            show_debug_message("P1 WINS!");
            alarm[0] = room_speed * 2;
        }
        else if (p2_exists && !p1_exists) {
            global.p2_wins += 1;
            global.round_over = true;
            show_debug_message("P2 WINS!");
            alarm[0] = room_speed * 2;
        }
        else if (!p1_exists && !p2_exists) {
            global.round_over = true;
            show_debug_message("DRAW!");
            alarm[0] = room_speed * 2;
        }
    }
}