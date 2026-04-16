pve_timer = room_speed * 90;

if (is_undefined(global.p1_character) || is_undefined(global.p2_character)) {
    show_debug_message("Missing character data!");
    room_goto(rm_character_select);
    exit;
}


// ===== SPAWN PLAYER 1 =====
var p1 = instance_create_layer(200, room_height/2, "Instances", obj_player1);
p1.owner_player = 1;
p1.character_data = global.p1_character;


// ===== SPAWN PLAYER 2 =====
var p2 = instance_create_layer(room_width - 200, room_height/2, "Instances", obj_player1);
p2.owner_player = 2;
p2.character_data = global.p2_character;