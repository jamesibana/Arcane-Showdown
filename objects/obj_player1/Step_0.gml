// SAFE INIT
if (!initialized && is_struct(character_data)) {
    hp = character_data.hp;
    move_speed = character_data.speed;
    initialized = true;
}

// movement
var h = 0;
var v = 0;

if (owner_player == 1) {
    h = keyboard_check(ord("D")) - keyboard_check(ord("A"));
    v = keyboard_check(ord("S")) - keyboard_check(ord("W"));
} else {
    h = keyboard_check(vk_right) - keyboard_check(vk_left);
    v = keyboard_check(vk_down) - keyboard_check(vk_up);
}

x += h * move_speed;
y += v * move_speed;

if (owner_player == 1) {
    x = clamp(x, 0, global.lane_mid);
} else {
    x = clamp(x, global.lane_mid, room_width);
}