// =====================================================
// DRAW GUI EVENT - MASTER UI
// =====================================================
if (room != rm_arena) exit;

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

// 🪄 HELPER FUNCTION: Draw Outlined Text
var _draw_text_outlined = function(_x, _y, _str, _in_col, _out_col) {
    draw_set_color(_out_col);
    draw_text(_x - 2, _y, _str); draw_text(_x + 2, _y, _str);
    draw_text(_x, _y - 2, _str); draw_text(_x, _y + 2, _str);
    draw_text(_x - 2, _y - 2, _str); draw_text(_x + 2, _y + 2, _str);
    draw_text(_x + 2, _y - 2, _str); draw_text(_x - 2, _y + 2, _str);
    draw_set_color(_in_col);
    draw_text(_x, _y, _str);
};

// =====================================================
// 🔍 LOCATE PLAYERS DYNAMICALLY
// =====================================================
var p1 = noone;
var p2 = noone;

with (obj_player1) {
    if (owner_player == 1) p1 = id;
    else if (owner_player == 2) p2 = id;
}

// =====================================================
// 1. TOP HUD (PORTRAITS, BARS & LIVES)
// =====================================================
draw_set_valign(fa_top);

var margin_x = 50;
var margin_y = 30;
var portrait_size = 64; 
var bar_w = 250;        
var bar_h = 18;         
var bar_gap = 6;        

// --- 🔴 PLAYER 1 (TOP LEFT) ---
if (p1 != noone) {
    var p1_name = "PLAYER 1";
    if (variable_instance_exists(p1, "character_data") && variable_struct_exists(p1.character_data, "name")) {
        p1_name = p1.character_data.name;
    }

    var px = margin_x;
    var py = margin_y + string_height(p1_name) + 5; 

    draw_set_halign(fa_left);
    _draw_text_outlined(px, margin_y, p1_name, c_white, c_red);

    // Portrait Frame Background
    draw_set_color(c_dkgray);
    draw_rectangle(px, py, px + portrait_size, py + portrait_size, false);

    // Aspect-Locked Half-Body Portrait
    if (sprite_exists(p1.sprite)) {
        var sw = sprite_get_width(p1.sprite);
        var sh = sprite_get_height(p1.sprite);
        var crop_h = sh * 0.65; 
        
        var uniform_scale = min(portrait_size / sw, portrait_size / crop_h);
        var x_offset = (portrait_size - (sw * uniform_scale)) / 2;
        var y_offset = (portrait_size - (crop_h * uniform_scale)) / 2;
        
        draw_sprite_part_ext(p1.sprite, 0, 0, 0, sw, crop_h, px + x_offset, py + y_offset, uniform_scale, uniform_scale, c_white, 1);
    }

    draw_set_color(c_red);
    draw_rectangle(px, py, px + portrait_size, py + portrait_size, true); 

    var bar_x = px + portrait_size + 15;
    var bar_y = py;

    // ARMOR BAR (Top)
    var armor_val = variable_instance_exists(p1, "armor") ? p1.armor : 0;
    var max_arm_val = variable_instance_exists(p1, "max_armor") ? p1.max_armor : 0;
    
    if (max_arm_val > 0) {
        var arm_pct = max(0, armor_val / max_arm_val);
        draw_set_color(c_black);
        draw_rectangle(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, false); 
        draw_set_color(c_aqua);
        draw_rectangle(bar_x, bar_y, bar_x + (bar_w * arm_pct), bar_y + bar_h, false); 
    } else {
        draw_set_color(c_black);
        draw_rectangle(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, false);
    }

    // HP BAR (Bottom)
    var hp_y = bar_y + bar_h + bar_gap;
    var hp_pct = max(0, p1.hp / p1.max_hp);
    
    draw_set_color(c_black);
    draw_rectangle(bar_x, hp_y, bar_x + bar_w, hp_y + bar_h, false); 
    draw_set_color(c_lime);
    draw_rectangle(bar_x, hp_y, bar_x + (bar_w * hp_pct), hp_y + bar_h, false); 

// ❤️ PLAYER 1 HEARTS
    var heart_scale = 2.5; 
    var heart_space = 18 * heart_scale; 
    
    // ⚙️ TWEAK THESE TO MOVE PLAYER 1'S HEARTS!
    // Example: change bar_x to (bar_x - 10) to move them left.
    var p1_heart_x = bar_x + 20; 
    var p1_heart_y = hp_y + bar_h + 16; 
    
    for (var i = 0; i < global.max_lives; i++) {
        var hx = p1_heart_x + (i * heart_space);
        
        if (i < global.p1_lives) {
            draw_sprite_ext(spr_heart_full, 0, hx, p1_heart_y, heart_scale, heart_scale, 0, c_white, 1);
        } else {
            draw_sprite_ext(spr_heart_full, 0, hx, p1_heart_y, heart_scale, heart_scale, 0, c_dkgray, 0.4);
        }
    }
}

// --- 🔵 PLAYER 2 (TOP RIGHT) ---
if (p2 != noone) {
    var p2_name = "PLAYER 2";
    if (variable_instance_exists(p2, "character_data") && variable_struct_exists(p2.character_data, "name")) {
        p2_name = p2.character_data.name;
    }

    var px = gui_w - margin_x - portrait_size;
    var py = margin_y + string_height(p2_name) + 5;

    draw_set_halign(fa_right);
    _draw_text_outlined(gui_w - margin_x, margin_y, p2_name, c_white, c_blue);

    // Portrait Frame Background
    draw_set_color(c_dkgray);
    draw_rectangle(px, py, px + portrait_size, py + portrait_size, false); 

    // Aspect-Locked Half-Body Portrait (Mirrored)
    if (sprite_exists(p2.sprite)) {
        var sw = sprite_get_width(p2.sprite);
        var sh = sprite_get_height(p2.sprite);
        var crop_h = sh * 0.65; 
        
        var uniform_scale = min(portrait_size / sw, portrait_size / crop_h);
        var x_offset = (portrait_size - (sw * uniform_scale)) / 2;
        var y_offset = (portrait_size - (crop_h * uniform_scale)) / 2;
        
        var right_edge = px + portrait_size - x_offset;
        draw_sprite_part_ext(p2.sprite, 0, 0, 0, sw, crop_h, right_edge, py + y_offset, -uniform_scale, uniform_scale, c_white, 1);
    }
    
    draw_set_color(c_blue);
    draw_rectangle(px, py, px + portrait_size, py + portrait_size, true);  

    var bar_x = px - 15 - bar_w;
    var bar_y = py;

    // ARMOR BAR (Top, Filling Right-to-Left)
    var armor_val = variable_instance_exists(p2, "armor") ? p2.armor : 0;
    var max_arm_val = variable_instance_exists(p2, "max_armor") ? p2.max_armor : 0;

    if (max_arm_val > 0) {
        var arm_pct = max(0, armor_val / max_arm_val);
        var missing_arm = bar_w * (1 - arm_pct);
        
        draw_set_color(c_black);
        draw_rectangle(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, false); 
        draw_set_color(c_aqua);
        draw_rectangle(bar_x + missing_arm, bar_y, bar_x + bar_w, bar_y + bar_h, false); 
    } else {
        draw_set_color(c_black);
        draw_rectangle(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, false);
    }

    // HP BAR (Bottom, Filling Right-to-Left)
    var hp_y = bar_y + bar_h + bar_gap;
    var hp_pct = max(0, p2.hp / p2.max_hp);
    var missing_hp = bar_w * (1 - hp_pct); 
    
    draw_set_color(c_black);
    draw_rectangle(bar_x, hp_y, bar_x + bar_w, hp_y + bar_h, false); 
    draw_set_color(c_lime);
    draw_rectangle(bar_x + missing_hp, hp_y, bar_x + bar_w, hp_y + bar_h, false); 

// ❤️ PLAYER 2 HEARTS (Filling Right-to-Left)
    var heart_scale = 2.5; 
    var heart_space = 18 * heart_scale; 
    var heart_w = sprite_get_width(spr_heart_full) * heart_scale;
    
    // ⚙️ TWEAK THESE TO MOVE PLAYER 2'S HEARTS!
    // Example: change (bar_x + bar_w) to (bar_x + bar_w + 10) to move them right.
    var p2_heart_x = (bar_x + bar_w + 18) - heart_w; 
    var p2_heart_y = hp_y + bar_h + 16; 
    
    for (var i = 0; i < global.max_lives; i++) {
        var hx = p2_heart_x - (i * heart_space); // Notice the minus sign to draw backwards!
        
        if (i < global.p2_lives) {
            draw_sprite_ext(spr_heart_full, 0, hx, p2_heart_y, heart_scale, heart_scale, 0, c_white, 1);
        } else {
            draw_sprite_ext(spr_heart_full, 0, hx, p2_heart_y, heart_scale, heart_scale, 0, c_dkgray, 0.4);
        }
    }
}


// =====================================================
// 2. CENTER ANNOUNCEMENTS (ROUND, 3, 2, 1, FIGHT / K.O.)
// =====================================================
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var cx = gui_w / 2;
var cy = gui_h / 3;

// --- START ANNOUNCEMENT ---
if (p1 != noone && p2 != noone && !global.round_over) {
    if (!global.round_active) {
        var txt = "";
        if (global.start_timer > 180) txt = "3";
        else if (global.start_timer > 120) txt = "2";
        else if (global.start_timer > 60) txt = "1";
        
        // 🥊 Draw the Round Number above the countdown
        draw_set_color(c_white);
        draw_text_transformed(cx, cy - 60, "ROUND " + string(global.current_round), 2, 2, 0);
        
        draw_set_color(c_yellow);
        draw_text_transformed(cx, cy, txt, 4, 4, 0); 
    } 
    else if (global.start_timer > 0) {
        draw_set_color(c_lime);
        draw_text_transformed(cx, cy, "FIGHT!", 4, 4, 0);
    }
}

// --- END ANNOUNCEMENT ---
if (global.round_over && global.end_timer <= 180) {
    draw_set_color(c_red);
    draw_text_transformed(cx, cy, "K.O.", 6, 6, 0); 
    
    draw_set_color(c_white);
    draw_text_transformed(cx, cy + 80, global.winner_text, 2, 2, 0); 
}

// =====================================================
// CLEANUP
// =====================================================
draw_set_valign(fa_top);
draw_set_halign(fa_left);
draw_set_color(c_white);