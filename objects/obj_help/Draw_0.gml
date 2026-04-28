// ============================
// BACKGROUND
// ============================
if (sprite_exists(spr_bg_select)) {
    draw_sprite_ext(
        spr_bg_select, 0, 
        room_width / 2, room_height / 2, 
        room_width / sprite_get_width(spr_bg_select), 
        room_height / sprite_get_height(spr_bg_select), 
        0, c_white, 1
    );
}

// ============================
// UI PANELS (BREATHING)
// ============================
var ui_pulse = 0.5 + sin(current_time / 250) * 0.2;

draw_set_alpha(ui_pulse);
draw_set_color(c_white);

if (sprite_exists(spr_char_select_ui_top)) {
    draw_sprite_ext(spr_char_select_ui_top, 0, room_width / 2, 90,
        room_width / sprite_get_width(spr_char_select_ui_top), 1, 0, c_white, 1);
}
if (sprite_exists(spr_char_select_ui_bottom)) {
    draw_sprite_ext(spr_char_select_ui_bottom, 0, room_width / 2, room_height - 70,
        room_width / sprite_get_width(spr_char_select_ui_bottom), 1, 0, c_white, 1);
}

draw_set_alpha(1);

// ============================
// TOP TEXT
// ============================
var top_y = 90;

draw_set_halign(fa_center);
draw_set_color(c_white);

// 1. Main Title
draw_text(room_width / 2, top_y, "GAME MANUAL");

// 2. Page Indicator
draw_set_color(c_yellow);
draw_text(room_width / 2, top_y + 40, "PAGE " + string(page + 1) + " OF " + string(max_pages));
draw_set_color(c_white);

// ============================
// PAGE CONTENT BACKGROUND (NEW)
// ============================
var box_w = room_width * 0.7; // Width of the text area
var box_h = room_height * 0.55; // Height of the text area
var cx = room_width / 2;
var cy = room_height * 0.25; 

var box_x1 = cx - (box_w / 2);
var box_y1 = cy - 20; // Slight padding above the first text line
var box_x2 = cx + (box_w / 2);
var box_y2 = box_y1 + box_h;

// Draw Translucent White Background
draw_set_alpha(0.65); // 65% opacity white
draw_set_color(c_white);
draw_roundrect(box_x1, box_y1, box_x2, box_y2, false); // Using roundrect for a smoother UI look
draw_set_alpha(1);

// ============================
// PAGE CONTENT TEXT
// ============================
var line_h = 45; 
var text_x = box_x1 + 40; // Left edge anchor for body text
var wrap_w = box_w - 80;  // Maximum width before text wraps

if (page == 0) {
    // ------------------------------------
    // PAGE 1: CONTROLS
    // ------------------------------------
    // Header (Centered)
    draw_set_halign(fa_center);
    draw_set_color(c_red); // Darker blue to read against white
    draw_text(cx, cy, "--- PLAYER 1 ---");
    
    // Body (Left Aligned)
    draw_set_halign(fa_left);
    draw_set_color(c_black); // Black text for readability
    draw_text(text_x, cy + line_h, "Move: W A S D   |   Swap/Pickup: Q");
    
    var p2_y = cy + (line_h * 2.5);
    
    // Header (Centered)
    draw_set_halign(fa_center);
    draw_set_color(c_blue);
    draw_text(cx, p2_y, "--- PLAYER 2 ---");
    
    // Body (Left Aligned)
    draw_set_halign(fa_left);
    draw_set_color(c_black);
    draw_text(text_x, p2_y + line_h, "Move: Arrow Keys   |   Swap/Pickup: CTRL");
    
    var combat_y = p2_y + (line_h * 2.5);
    
    // Header (Centered)
    draw_set_halign(fa_center);
    draw_set_color(c_maroon);
    draw_text(cx, combat_y, "--- COMBAT MECHANICS ---");
    
    // Body (Left Aligned)
    draw_set_halign(fa_left);
    draw_set_color(c_black);
    draw_text(text_x, combat_y + line_h, "Basic Attack / Fire: Double-tap movement keys");
    draw_text(text_x, combat_y + (line_h * 1.8), "Combo Attack: Left/Right + Up + Down");
    draw_text(text_x, combat_y + (line_h * 2.6), "Block Combo: Attack at the same time as opponent's combo");
} 
else if (page == 1) {
    // ------------------------------------
    // PAGE 2: HOW TO PLAY
    // ------------------------------------
    var txt_y = cy;
    
    // Header (Centered)
    draw_set_halign(fa_center);
    draw_set_color(c_green); // Darker green
    draw_text(cx, txt_y, "PHASE 1: CRAWLER PHASE");
    
    // Body (Left Aligned)
    draw_set_halign(fa_left);
    draw_set_color(c_black);
    var p1_text = "Attack monsters to get new weapons! Some monsters are weak, some are tanky, and some deal high damage. The stronger the enemy, the higher the chances it drops weapons.";
    
    // ADJUST THE Y HERE:
    draw_text_ext(text_x, txt_y + line_h + 65, p1_text, 35, wrap_w); 
    
    // ==========================================
    // 🛑 THE FIX: Define phase2_y right here!
    // ==========================================
    var phase2_y = txt_y + (line_h * 5.5); // Push the whole section down
    
    // Header (Centered)
    draw_set_halign(fa_center);
    draw_set_color(c_red);
    draw_text(cx, phase2_y, "PHASE 2: ARENA PHASE");
    
    // Body (Left Aligned)
    draw_set_halign(fa_left);
    draw_set_color(c_black);
    var p2_text = "Fight to the death against the other player! A sandstorm will appear in the arena; going inside will poison your armor and health.";
    
    // ADJUST THE Y HERE:
    draw_text_ext(text_x, phase2_y + line_h + 50, p2_text, 35, wrap_w);
}

// ============================
// BOTTOM HELP TEXT
// ============================
var bottom_y = room_height - 70;

draw_set_halign(fa_center);
draw_set_color(c_white);
draw_text(room_width / 2, bottom_y, "A / D or LEFT / RIGHT to turn pages | ESC to return");

// Reset alignment just to be safe
draw_set_halign(fa_left);