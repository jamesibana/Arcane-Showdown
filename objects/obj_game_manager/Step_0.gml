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

        // prevent overcrowding
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

        // difficulty scaling
        global.time_spawn_interval = max(room_speed * 3, global.time_spawn_interval - 8);
        global.time_spawn_timer = global.time_spawn_interval;
    }
}


// =====================================================
// 4. HIT PAUSE SYSTEM (GLOBAL)
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
p1_exists = false;
p2_exists = false;

with (obj_player1) {
    if (!variable_instance_exists(id, "owner_player")) continue; 

    var my_id = real(owner_player); 
    var my_state = string_lower(string(state));

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
        global.start_timer--;
    }

// C. MONITOR FOR WINNER
    if (global.round_active) {
        if (p1_exists && !p2_exists) {
            // REMOVED global.p1_wins += 1; here!
            global.round_active = false; 
            global.round_over = true;
            global.end_timer = 240; 
            global.winner_text = "PLAYER 1 WINS ROUND!"; 
        }
        else if (p2_exists && !p1_exists) {
            // REMOVED global.p2_wins += 1; here!
            global.round_active = false; 
            global.round_over = true;
            global.end_timer = 240; 
            global.winner_text = "PLAYER 2 WINS ROUND!";
        }
        else if (!p1_exists && !p2_exists) {
            global.round_active = false; 
            global.round_over = true;
            global.end_timer = 240; 
            global.winner_text = "DOUBLE K.O.!";
        }
    }
}

// =====================================================
// 8. ARENA ROUND RESET CONTROLLER
// =====================================================
if (global.round_over) {
    
    global.end_timer--;
    
    // When the 4-second K.O. screen finishes...
    if (global.end_timer <= 0) {
        
        // 1. Deduct lives based on who died
        with (obj_player1) {
            if (state == "dead") {
                if (owner_player == 1) { global.p1_lives--; }
                if (owner_player == 2) { global.p2_lives--; }
            }
        }
        
// 2. CHECK FOR MATCH OVER
        if (global.p1_lives <= 0 || global.p2_lives <= 0) {
            
            // 🏆 THE FIX: Only award the overall Match Win when all lives are depleted!
            // Placing it inside the alarm check ensures it strictly triggers only once.
            if (alarm[0] < 0) { 
                
                // Check who survived to award the final point
                if (global.p1_lives > 0 && global.p2_lives <= 0) {
                    global.p1_wins += 1;
                    global.winner_text = "PLAYER 1 WINS MATCH!"; // Optional UI update
                } 
                else if (global.p2_lives > 0 && global.p1_lives <= 0) {
                    global.p2_wins += 1;
                    global.winner_text = "PLAYER 2 WINS MATCH!";
                }

                alarm[0] = 120; // Wait 2 seconds, then execute Alarm 0 to leave the room
            }
            
            show_debug_message("MATCH OVER"); 
        }
        // 3. NEXT ROUND RESET
        else {
            global.current_round++;
            global.round_active = false;
            global.round_over = false;
            global.start_timer = 240; // Reset "3, 2, 1" timer
            
            // 🔄 Reset the Sandstorm Ring to its starting size
            with (obj_arena_poison_ring) { event_perform(ev_create, 0); }
            

// 🔄 Respawn the Players
            with (obj_player1) {
                state = "alive";
                hp = max_hp;
                
                // Safely restore entry armor
                if (variable_instance_exists(id, "entry_armor")) {
                    armor = entry_armor; 
                }
                
                // 📍 THE FIX: Explicit Arena Spawn Points
                // This forces them to perfect fighting game positions regardless of where they died!
                if (owner_player == 1) {
                    x = room_width * 0.25; // Left side (25% into the room)
                    image_xscale = 1;      // Face Right
                } 
                else if (owner_player == 2) {
                    x = room_width * 0.75; // Right side (75% into the room)
                    image_xscale = -1;     // Face Left
                }
                
                // Spawn them slightly high up so GameMaker's gravity 
                // drops them perfectly onto the arena floor!
                y = room_height * 0.75; 
                
                // Reset visuals
                image_alpha = 1;
                image_angle = 0;
                
                // Clear any lingering statuses
                vsp = 0;
                hurt_timer = 0;
                poison_timer = 0;
                in_poison_ring = false;
                hitstun_timer = 0;
                attack_cooldown = 0;
            }
        }
    }
}