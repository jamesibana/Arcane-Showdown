// =====================================================
// ALARM 0: ROUND CLEANUP & TRANSITION
// =====================================================

// 1. DESTROY ALL LINGERING OBJECTS 
// (This kills the winning player so they don't haunt the next round)
with (obj_player1) {
    instance_destroy();
}

// Optional: Clean up any lingering projectiles, pickups, or enemies
with (obj_enemy_parent) { instance_destroy(); }
with (obj_projectile) { instance_destroy(); }
with (obj_weapon_pickup) { instance_destroy(); }

// 2. RESET CHARACTER SELECT VARIABLES
// (Forces the menu to start back at Player 1)
global.current_player = 1;
global.p1_character = undefined;
global.p2_character = undefined;

// 3. FINALLY, GO TO THE MENU
room_goto(rm_character_select);