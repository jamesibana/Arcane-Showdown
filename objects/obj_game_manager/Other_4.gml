if (room == rm_arena) {
    global.round_over = false;
    global.round_active = false;
    
    // 240 frames total (4 seconds at 60fps) -> 3.. 2.. 1.. FIGHT!
    global.start_timer = 240; 
    
    // 180 frames (3 seconds) to let the K.O. text hang on screen
    global.end_timer = 240;   
    
    global.winner_text = "";
}