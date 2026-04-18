var c = global.characters[index];

var wins = (global.current_player == 1)
    ? global.p1_wins
    : global.p2_wins;

var locked = (c.unlock_wins > wins);

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


if (keyboard_check_pressed(vk_enter)) {

    c = global.characters[index];

     wins = (global.current_player == 1)
        ? global.p1_wins
        : global.p2_wins;

     locked = (c.unlock_wins > wins);

    // ❌ BLOCK IF LOCKED
    if (locked) {
        exit; // or just do nothing
    }

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
