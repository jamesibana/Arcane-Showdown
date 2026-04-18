// SAFE INIT
if (!initialized && is_struct(character_data)) {
    hp = character_data.hp;
    move_speed = character_data.speed;
    initialized = true;
}

// INPUT
var h = 0;
var v = 0;

if (owner_player == 1) {
    h = keyboard_check(ord("D")) - keyboard_check(ord("A"));
    v = keyboard_check(ord("S")) - keyboard_check(ord("W"));
}
else {
    h = keyboard_check(vk_right) - keyboard_check(vk_left);
    v = keyboard_check(vk_down) - keyboard_check(vk_up);
}

// SAFE MOVEMENT WITH WALL
var new_x = x + h * move_speed;
var new_y = y + v * move_speed;

// X movement
if (!place_meeting(new_x, y, obj_wall_segment)) {
    x = new_x;
}

// Y movement
if (!place_meeting(x, new_y, obj_wall_segment)) {
    y = new_y;
}

