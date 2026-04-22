// =====================================================
// ARENA SETUP
// =====================================================
if (room == rm_arena) {
    global.round_over = false;
    global.round_active = false;
    
    global.start_timer = 240; 
    global.end_timer = 180;   
    global.winner_text = "";
}

// =====================================================
// CRAWLER (PvE) SETUP
// =====================================================
if (room == rm_crawler) {
    
    // 1. THIS FIXES YOUR BUG: Force the initial spawn to run again!
    global.initial_spawn_done = false;
    
    // 2. Reset the wave timers and kills so the difficulty resets for the new round
    global.enemy_kills = 0;
    
    if (variable_global_exists("time_spawn_interval")) {
        global.time_spawn_timer = global.time_spawn_interval;
    }
}