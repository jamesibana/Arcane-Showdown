// =====================================================
// DYNAMIC ARENA SCALING
// =====================================================
var scale_mult = (room == rm_arena) ? 2 : 1; 

// WE DELETED image_xscale and image_yscale! 
// Now, just use image_xscale and image_yscale for all your draw_sprite_ext functions!

// ============================
// DRAW PLAYER WITH Y-OFFSET
// ============================
var y_offset = 32 * scale_mult; 
var py = y - y_offset; 

// ------------------------------------
// 1. DYNAMIC OUTLINE
// ------------------------------------
var outline_color = (owner_player == 1) ? c_red : c_blue;
var outline_alpha = 0.6; 
var thickness = 2 * scale_mult; // Thicker outline for a bigger sprite!

gpu_set_fog(true, outline_color, 0, 0); 

// Draw the 4 main directions using our dynamically scaled variables
draw_sprite_ext(sprite_index, image_index, x + thickness, py, image_xscale, image_yscale, image_angle, outline_color, outline_alpha);
draw_sprite_ext(sprite_index, image_index, x - thickness, py, image_xscale, image_yscale, image_angle, outline_color, outline_alpha);
draw_sprite_ext(sprite_index, image_index, x, py + thickness, image_xscale, image_yscale, image_angle, outline_color, outline_alpha);
draw_sprite_ext(sprite_index, image_index, x, py - thickness, image_xscale, image_yscale, image_angle, outline_color, outline_alpha);

gpu_set_fog(false, c_white, 0, 0);


// ------------------------------------
// 2. ACTUAL PLAYER SPRITE
// ------------------------------------
draw_sprite_ext(
    sprite_index, 
    image_index, 
    x, 
    py, 
    image_xscale, // 👈 Using the scaled X
    image_yscale, // 👈 Using the scaled Y
    image_angle, 
    image_blend, 
    image_alpha
);

// =====================================================
// DRAW WEAPON (PROCEDURAL ANIMATION)
// =====================================================
var wep_x = x;
var wep_y = py; // Snaps directly to our newly scaled Y!
var wep_angle = 0;
var safe_cooldown = max(cooldown, 1);

// 1. IDLE STATE
if (attack_cooldown <= 0) {
    wep_angle = (image_xscale == 1) ? 0 : 0; 
    
    // Scale the rest position offsets
    wep_x -= sign(image_xscale) * (5 * scale_mult); 
    wep_y += (5 * scale_mult); 
} 

// 2. ATTACKING STATE
else {
    var progress = 1 - (attack_cooldown / safe_cooldown);

    // ---------- MELEE (SWING) ----------
    if (active_weapon_type == "melee") {
        var start_angle = (image_xscale == 1) ? 50 : -50;   
        var end_angle   = (image_xscale == 1) ? -135 : 135; 

        wep_angle = lerp(start_angle, end_angle, progress);

        // Scale the forward lunge reach!
        var reach = sin(progress * pi) * (15 * scale_mult); 
        wep_x += lengthdir_x(reach, facing_dir);
        wep_y += lengthdir_y(reach, facing_dir);
    } 
    
    // ---------- RANGED (RECOIL) ----------
    else {
        wep_angle = facing_dir; 
        
        // Scale the gun recoil jump!
        var recoil = sin(progress * pi) * (-8 * scale_mult); 
        wep_x += lengthdir_x(recoil, facing_dir);
        wep_y += lengthdir_y(recoil, facing_dir);
    }
}

// --- DRAW WEAPON OUTLINE ---
gpu_set_fog(true, c_black, 0, 0); 
var wep_thick = 1 * scale_mult; // Scale weapon outline too!

draw_sprite_ext(weapon_sprite, 0, wep_x + wep_thick, wep_y, image_xscale, image_yscale, wep_angle, c_black, 1);
draw_sprite_ext(weapon_sprite, 0, wep_x - wep_thick, wep_y, image_xscale, image_yscale, wep_angle, c_black, 1);
draw_sprite_ext(weapon_sprite, 0, wep_x, wep_y + wep_thick, image_xscale, image_yscale, wep_angle, c_black, 1);
draw_sprite_ext(weapon_sprite, 0, wep_x, wep_y - wep_thick, image_xscale, image_yscale, wep_angle, c_black, 1);

gpu_set_fog(false, c_white, 0, 0); 

// --- DRAW ACTUAL WEAPON ---
draw_sprite_ext(weapon_sprite, 0, wep_x, wep_y, image_xscale, image_yscale, wep_angle, c_white, 1);


// ============================
// PLAYER INDICATOR (SPRITE VERSION)
// ============================
// 🐛 Fixed bug here: changed `y_offset(sprite_index)` to `y_offset` so it doesn't crash!
var ind_y = py - (60 * scale_mult); // Automatically floats higher if the player gets bigger
var ind_x = x;

var spr = (owner_player == 1) ? spr_indicator_1 : spr_indicator_2;
draw_sprite(spr, 0, ind_x, ind_y);


// =====================================================
// PLAYER BARS (DYNAMIC ROOM)
// =====================================================
if (room != rm_arena) {

    var fixed_bar_w = 60; 
    var bar_h = 4;

    var bx = x - (fixed_bar_w / 2);
    var by = y - 70;

    var hp_percent = clamp(hp / max(1, max_hp), 0, 1);
    var armor_percent = 0; 
    if (max_armor > 0) {
        armor_percent = clamp(armor / max_armor, 0, 1);
    }

    if (max_armor > 0) {
        draw_set_color(c_gray);
        draw_rectangle(bx, by, bx + fixed_bar_w, by + bar_h, false);

        draw_set_color(c_aqua);
        draw_rectangle(bx, by, bx + (fixed_bar_w * armor_percent), by + bar_h, false);
    }

    draw_set_color(c_black);
    draw_rectangle(bx, by + 6, bx + fixed_bar_w, by + 6 + bar_h, false);

    draw_set_color(c_lime);
    draw_rectangle(bx, by + 6, bx + (fixed_bar_w * hp_percent), by + 6 + bar_h, false);

    draw_set_color(c_white); 
}
