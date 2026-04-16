pve_timer = room_speed * 90;

// ===== DEBUG =====
show_debug_message("P1 exists: " + string(!is_undefined(global.p1_character)));
show_debug_message("P2 exists: " + string(!is_undefined(global.p2_character)));


// ===== SAFETY CHECK =====
if (is_undefined(global.p1_character) || is_undefined(global.p2_character)) {
    show_debug_message("ERROR: Character data missing! Returning to select.");
    room_goto(rm_character_select);
    exit;
}


// ===== SPAWN PLAYER 1 =====
var p1 = instance_create_layer(200, 300, "Instances", obj_player);
p1.owner_player = 1;
p1.character_data = global.p1_character;


// ===== SPAWN PLAYER 2 =====
var p2 = instance_create_layer(600, 300, "Instances", obj_player);
p2.owner_player = 2;
p2.character_data = global.p2_character;