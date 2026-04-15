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
if (keyboard_check_pressed(vk_enter)) {

    if (!is_locked) {

        // assign character to correct player
        if (global.current_player == 1) {
            global.p1_character = c;
            global.current_player = 2;
            index = 0; // reset selection for player 2
        }
        else {
            global.p2_character = c;

            // proceed to PvE
            room_goto(rm_crawler);
        }
    }
}