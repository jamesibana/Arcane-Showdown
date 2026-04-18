
// make persistent so it never resets
persistent = true;

// init
if (!variable_global_exists("music_id")) {
    global.music_id = -1;
}

if (!variable_global_exists("game_state")) {
    global.game_state = "menu"; // menu or game
}

// START MENU MUSIC ONLY ONCE
if (global.music_id == -1) {
    global.music_id = audio_play_sound(mus_select, 1, true);
}