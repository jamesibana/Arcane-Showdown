// Play your click/select sound 
// (You might want to change snd_music to a UI sound like snd_select if you have one!)
audio_play_sound(snd_music, 0, false);

// Teleport the player to the new Help Menu room!
room_goto(rm_help_menu);