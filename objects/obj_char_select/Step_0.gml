var c = global.characters[index];

var wins = (global.current_player == 1)
    ? global.p1_wins
    : global.p2_wins;

var locked = (c.unlock_wins > wins);

// ============================
// SCREEN SHAKE UPDATE (NEW)
// ============================
if (shake_timer > 0) {
    shake_timer--;
}

// ============================
// CHARACTER MOVE ANIMATION (NEW)
// ============================
move_anim = lerp(move_anim, index, 0.2);

// ============================
// NAVIGATION (TURN-BASED INPUT)
// ============================
if (global.current_player == 1) {

    if (keyboard_check_pressed(ord("D"))) index++;
    if (keyboard_check_pressed(ord("A"))) index--;
}

if (global.current_player == 2) {

    if (keyboard_check_pressed(vk_right)) index++;
    if (keyboard_check_pressed(vk_left))  index--;
}

// ============================
// WRAP INDEX
// ============================
var char_count = array_length(global.characters);
index = (index + char_count) mod char_count;

// ============================
// CONFIRM SELECTION
// ============================
if (keyboard_check_pressed(vk_enter)) {

    c = global.characters[index];

    wins = (global.current_player == 1)
        ? global.p1_wins
        : global.p2_wins;

    locked = (c.unlock_wins > wins);

    // BLOCK IF LOCKED
    if (locked) {
        shake_timer = 10;
        shake_power = 5;
        exit;
    }

    // ============================
    // CONFIRM EFFECT (NEW)
    // ============================
    shake_timer = 12;
    shake_power = 6;

// audio_play_sound(snd_select, 1, false);

    confirming = true;

    // ============================
    // SELECT CHARACTER
    // ============================
    if (global.current_player == 1) {

        global.p1_character = c;
        global.current_player = 2;
        index = 0;

    } else {

        global.p2_character = c;
        room_goto(rm_crawler);
    }
}

show_debug_message("INDEX: " + string(index) + " CHAR: " + global.characters[index].name);
