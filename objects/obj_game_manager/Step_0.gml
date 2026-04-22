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
// 6. FIND PLAYERS 
// =====================================================
// Notice: We removed "var " so these are now Instance Variables shared with Draw GUI!
p1_exists = false;
p2_exists = false;

with (obj_player1) {
    
    if (!variable_instance_exists(id, "owner_player")) continue; 

    var my_id = real(owner_player); 
    var my_state = string_lower(string(state));

    // Notice: We put "other." back because p1_exists is now an instance variable on the manager!
    if (my_id == 1 && my_state != "dead") other.p1_exists = true;
    if (my_id == 2 && my_state != "dead") other.p2_exists = true;
}

// =====================================================
// 7. ROUND FLOW & WIN LOGIC
// =====================================================
if (!global.round_over) {

    // A. ROUND START COUNTDOWN
    if (!global.round_active) {
        if (p1_exists && p2_exists) {
            if (global.start_timer > 0) {
                global.start_timer--;
                
                // At 60 frames (1 second left), activate the round and say FIGHT!
                if (global.start_timer == 60) {
                    global.round_active = true;
                }
            }
        }
    } 
    // B. FADE OUT "FIGHT!" TEXT
    else if (global.start_timer > 0) {
        // Keep ticking down the last 60 frames to hide the text
        global.start_timer--;
    }

    // C. MONITOR FOR WINNER (Only if round is active!)
    if (global.round_active) {
        if (p1_exists && !p2_exists) {
            global.p1_wins += 1;
            global.round_over = true;
            global.winner_text = "PLAYER 1 WINS!";
        }
        else if (p2_exists && !p1_exists) {
            global.p2_wins += 1;
            global.round_over = true;
            global.winner_text = "PLAYER 2 WINS!";
        }
        else if (!p1_exists && !p2_exists) {
            global.round_over = true;
            global.winner_text = "DOUBLE K.O.!";
        }
    }
} 
// D. ROUND END (K.O.) COUNTDOWN
else {
    if (global.end_timer > 0) {
        global.end_timer--;
    } else {
        // Time is up! Trigger the cleanup alarm
        if (alarm[0] < 0) alarm[0] = 1; 
    }
}