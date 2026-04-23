var new_music = noone;

// ===================================
// ANONG MUSIC PER ROOM
// ===================================
switch (room) {
    
    case rm_menu:
    case rm_help_menu:
        new_music = snd_music;
        break;
        
    case rm_character_select:
        new_music = snd_music_select;
        break;
        
    case rm_crawler:
        new_music = snd_music_crawler;
        break;
        
    case rm_arena:
        new_music = snd_music_arena;
        break;
}

// ===================================
// PALIT MUSIC (IF NEEDED LANG)
// ===================================
if (new_music != global.target_music) {
    
    // stop old music kung meron
    if (global.current_music != noone) {
        if (audio_is_playing(global.current_music)) {
            audio_stop_sound(global.current_music);
        }
    }
    
    // play new music (looping)
    if (new_music != noone) {
        global.current_music = audio_play_sound(new_music, 100, true);
    }
    
    // update tracker
    global.target_music = new_music;
}