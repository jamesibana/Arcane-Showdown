// ============================
// GET CURRENT CHARACTER
// ============================
var c = global.characters[index];


// ============================
// GET PLAYER WINS (P1 / P2)
// ============================
var player_wins = 0;

if (global.current_player == 1) {
    player_wins = global.p1_wins;
} else {
    player_wins = global.p2_wins;
}


// ============================
// NAVIGATION
// ============================
if (keyboard_check_pressed(vk_right)) {
    index++;
}

if (keyboard_check_pressed(vk_left)) {
    index--;
}


// wrap around
if (index < 0) {
    index = array_length(global.characters) - 1;
}
if (index >= array_length(global.characters)) {
    index = 0;
}


// ============================
// LOCK CHECK (real-time feedback)
// ============================
is_locked = (c.unlock_wins > player_wins);


// ============================
// SELECT CHARACTER (ENTER)
// ============================
// get current character AFTER index updates
var c = global.characters[index];

// ENTER to select
if (keyboard_check_pressed(vk_enter)) {

    if (!is_locked) {

        if (global.current_player == 1) {
            global.p1_character = c;
            show_debug_message("P1 set: " + c.name);

            global.current_player = 2;
            index = 0;
        }
        else {
            global.p2_character = c;
            show_debug_message("P2 set: " + c.name);

            // DEBUG CHECK BEFORE ROOM CHANGE
            show_debug_message("Going to PvE");

            room_goto(rm_crawler);
        }
    }
}