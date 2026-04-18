// change state
global.game_state = "game";

// stop any music
audio_stop_all();
global.music_id = -1;

// go to arena
room_goto(rm_arena);

// NOTE: play music AFTER room loads (IMPORTANT)

if (global.music_id != -1) {
    audio_stop_sound(global.music_id);
}

global.music_id = audio_play_sound(snd_music, 1, true);