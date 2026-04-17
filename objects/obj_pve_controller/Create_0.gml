pve_timer = room_speed * 60; //60 sec timer

// safety check
if (!is_struct(global.p1_character) || !is_struct(global.p2_character)) {
    room_goto(rm_character_select);
    exit;
}

var mid = room_width / 2;

// spawn players
var p1 = instance_create_layer(mid/2, room_height/2, "Instances", obj_player1);
p1.owner_player = 1;
p1.character_data = global.p1_character;

var p2 = instance_create_layer(mid + mid/2, room_height/2, "Instances", obj_player1);
p2.owner_player = 2;
p2.character_data = global.p2_character;

p1.character_data = global.p1_character;
p1.sprite_index = p1.character_data.sprite;

p2.character_data = global.p2_character;
p2.sprite_index = p2.character_data.sprite;

//room separate
global.lane_mid = room_width / 2;