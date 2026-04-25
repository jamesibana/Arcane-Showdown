// =====================================================
// ALARM 0: ROUND CLEANUP & TRANSITION
// =====================================================

// 1. DESTROY ALL LINGERING OBJECTS 
with (obj_player1) { instance_destroy(); }
with (obj_enemy_parent) { instance_destroy(); }
with (obj_projectile) { instance_destroy(); }
with (obj_weapon_pickup) { instance_destroy(); }
with (obj_arena_poison_ring) { instance_destroy(); } 

// 2. RESET CHARACTER SELECT VARIABLES
global.current_player = 1;
global.p1_character = undefined;
global.p2_character = undefined;

// 3. 🛑 RESET THE ROUND STATE FLAGS FOR THE NEXT MATCH
global.round_active = false;
global.round_over = false;
global.current_round = 1;
global.hitpause = 0;

// ❤️ THE FIX: Refill both players' lives for the new game!
if (variable_global_exists("max_lives")) {
    global.p1_lives = global.max_lives;
    global.p2_lives = global.max_lives;
} else {
    // Fallback just in case!
    global.p1_lives = 2;
    global.p2_lives = 2;
}

// 4. FINALLY, GO TO THE MENU
room_goto(rm_character_select);