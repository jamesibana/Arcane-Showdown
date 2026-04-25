/**
// =====================================================
// ARENA UI BARS (DRAW GUI EVENT)
// =====================================================
// 1. Only show this UI in the arena!
if (room != rm_arena) exit;

// 2. Set up our Big UI Dimensions
var bar_w = 300;  // How wide the big bars are
var bar_h = 18;   // How thick the big bars are
var padding = 30; // How far away from the edges of the screen they sit

// 3. Safety Math (Same as your small bars)
var hp_percent = clamp(hp / max(1, max_hp), 0, 1);
var armor_percent = 0; 
if (max_armor > 0) {
    armor_percent = clamp(armor / max_armor, 0, 1);
}


// =====================================================
// PLAYER 1 (TOP LEFT)
// =====================================================
if (owner_player == 1) {
    
    var px = padding;
    var py = padding;

    // --- ARMOR ---
    if (max_armor > 0) {
        draw_set_color(c_gray);
        draw_rectangle(px, py, px + bar_w, py + bar_h, false);
        
        draw_set_color(c_aqua);
        draw_rectangle(px, py, px + (bar_w * armor_percent), py + bar_h, false);
    }

    // --- HP ---
    var hp_y = py + bar_h + 4; // Shift down slightly to sit under Armor
    
    draw_set_color(c_black);
    draw_rectangle(px, hp_y, px + bar_w, hp_y + bar_h, false);
    
    draw_set_color(c_lime);
    draw_rectangle(px, hp_y, px + (bar_w * hp_percent), hp_y + bar_h, false);
}


// =====================================================
// PLAYER 2 (TOP RIGHT)
// =====================================================
else if (owner_player == 2) {
    
    // Find the exact right-side edge of the player's screen/window
    var gui_w = display_get_gui_width();
    
    // px is now the far RIGHT edge of the bar!
    var px = gui_w - padding; 
    var py = padding;

    // --- ARMOR ---
    if (max_armor > 0) {
        draw_set_color(c_gray);
        draw_rectangle(px - bar_w, py, px, py + bar_h, false);
        
        // This math makes it shrink towards the right!
        draw_set_color(c_aqua);
        draw_rectangle(px - (bar_w * armor_percent), py, px, py + bar_h, false);
    }

    // --- HP ---
    var hp_y = py + bar_h + 4;
    
    draw_set_color(c_black);
    draw_rectangle(px - bar_w, hp_y, px, hp_y + bar_h, false);
    
    draw_set_color(c_lime);
    draw_rectangle(px - (bar_w * hp_percent), hp_y, px, hp_y + bar_h, false);
}

draw_set_color(c_white); // Always reset color!