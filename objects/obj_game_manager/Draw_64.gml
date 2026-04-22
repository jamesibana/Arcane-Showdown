if (room != rm_arena) exit;

// Center the text
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var cx = display_get_gui_width() / 2;
var cy = display_get_gui_height() / 3;

// ============================
// START ANNOUNCEMENT
// ============================
if (p1_exists && p2_exists && !global.round_over) {
    
    // Draw 3, 2, 1
    if (!global.round_active) {
        var txt = "";
        if (global.start_timer > 180) txt = "3";
        else if (global.start_timer > 120) txt = "2";
        else if (global.start_timer > 60) txt = "1";
        
        draw_set_color(c_yellow);
        draw_text_transformed(cx, cy, txt, 4, 4, 0); // Draws text 4x larger!
    } 
    // Draw FIGHT! (For the final 60 frames)
    else if (global.start_timer > 0) {
        draw_set_color(c_lime);
        draw_text_transformed(cx, cy, "FIGHT!", 4, 4, 0);
    }
}

// ============================
// END ANNOUNCEMENT
// ============================
// The text will ONLY appear when the timer drops to 120 or below
if (global.round_over && global.end_timer <= 180) {
    draw_set_color(c_red);
    draw_text_transformed(cx, cy, "K.O.", 6, 6, 0); // Massive K.O.
    
    draw_set_color(c_white);
    draw_text_transformed(cx, cy + 80, global.winner_text, 2, 2, 0); // Winner name below
}

// Reset alignments so other UI doesn't break
draw_set_valign(fa_top);
draw_set_halign(fa_left);