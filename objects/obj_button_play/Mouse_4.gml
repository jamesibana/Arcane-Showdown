if (!global.game_started) {
    global.game_started = true;
    audio_play_sound(snd_music, 0, false);
    room_goto(rm_character_select);
}