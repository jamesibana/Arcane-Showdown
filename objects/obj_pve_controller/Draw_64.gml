draw_set_font(fnt_menu);
draw_set_halign(fa_center);
draw_set_color(c_white); 

var seconds = ceil(pve_timer / room_speed);
var center_x = display_get_gui_width() / 2; // Calculate the center once!

// Draw the main timer using the true GUI center
draw_text(center_x, 20, "PvE Time: " + string(seconds));

// =====================================================
// 💡 TUTORIAL TEXT
// =====================================================
if (instruction_timer > 0) {
    
    // Force the text to be completely opaque (solid) and white
    draw_set_alpha(1.0); 
    draw_set_color(c_white); 
    
    var center_x = display_get_gui_width() / 2;
    
    // ⚙️ TWEAK THIS: 
    // display_get_gui_height() is the absolute bottom pixel of your screen.
    // Subtracting 50 bumps it up just enough so it isn't touching the edge.
    var bottom_y = display_get_gui_height() - 50; 
    
    draw_text(center_x, bottom_y, "Attack monsters to get weapons, don't lose your armor!");
}