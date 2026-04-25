
// ============================
// DRAW PLAYER WITH Y-OFFSET
// ============================
var y_offset = 32; 
var py = y - y_offset; // Store the shifted Y so we don't have to calculate it 5 times!

// ------------------------------------
// 1. DYNAMIC OUTLINE
// ------------------------------------
var outline_color = (owner_player == 1) ? c_red : c_blue;
var outline_alpha = 0.6; 

// 👇 NEW: Change this number to make the outline thicker!
var thickness = 2; 

gpu_set_fog(true, outline_color, 0, 0); 

// Draw the 4 main directions using our new thickness variable
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
    py, // Using our saved py variable!
    image_xscale, 
    image_yscale, 
    image_angle, 
    image_blend, 
    image_alpha
);

// =====================================================
// DRAW WEAPON (PROCEDURAL ANIMATION)
// =====================================================
var wep_x = x;
var wep_y = y - y_offset;
var wep_angle = 0;

// Prevent division by zero
var safe_cooldown = max(cooldown, 1);

// 1. IDLE STATE
if (attack_cooldown <= 0) {
    // Hold the weapon at a relaxed diagonal angle
    wep_angle = (image_xscale == 1) ? 0 : 0; 
    
    // Shift it slightly to the player's side
    wep_x -= image_xscale * 5; 
    wep_y += 5; // Lower it a bit while resting
} 

// 2. ATTACKING STATE
else {
    // Convert the cooldown timer into an animation percentage (0.0 to 1.0)
    // 0.0 = Start of attack | 1.0 = End of attack
    var progress = 1 - (attack_cooldown / safe_cooldown);

    // ---------- MELEE (SWING) ----------
    if (active_weapon_type == "melee") {
        
        // Define the swing arc based on which way we are facing
        var start_angle = (image_xscale == 1) ? 50 : -50;   // Pulled back
        var end_angle   = (image_xscale == 1) ? -135 : 135;  // Slammed forward

        // lerp() smoothly transitions between the start and end angle based on our progress
        wep_angle = lerp(start_angle, end_angle, progress);

        // Add a satisfying "lunge" forward using sine wave math
        var reach = sin(progress * pi) * 15; 
        wep_x += lengthdir_x(reach, facing_dir);
        wep_y += lengthdir_y(reach, facing_dir);
    } 
    
    // ---------- RANGED (RECOIL) ----------
    else {
        wep_angle = facing_dir; // Always point at the crosshair/target
        
        // Snap backward, then slowly recover to original position
        var recoil = sin(progress * pi) * -8; 
        wep_x += lengthdir_x(recoil, facing_dir);
        wep_y += lengthdir_y(recoil, facing_dir);
    }
}

// Actually draw the weapon using the math we just calculated
// --- DRAW WEAPON OUTLINE ---
// Draw the weapon in pure black 1 pixel in every direction
gpu_set_fog(true, c_black, 0, 0); // Force the sprite to draw as a solid color

draw_sprite_ext(weapon_sprite, 0, wep_x + 1, wep_y, image_xscale, 1, wep_angle, c_black, 1);
draw_sprite_ext(weapon_sprite, 0, wep_x - 1, wep_y, image_xscale, 1, wep_angle, c_black, 1);
draw_sprite_ext(weapon_sprite, 0, wep_x, wep_y + 1, image_xscale, 1, wep_angle, c_black, 1);
draw_sprite_ext(weapon_sprite, 0, wep_x, wep_y - 1, image_xscale, 1, wep_angle, c_black, 1);

gpu_set_fog(false, c_white, 0, 0); // Turn off the solid color effect

// --- DRAW ACTUAL WEAPON ---
draw_sprite_ext(weapon_sprite, 0, wep_x, wep_y, image_xscale, 1, wep_angle, c_white, 1);

// ============================
// PLAYER INDICATOR (SPRITE VERSION)
// ============================

var ind_y = y - y_offset(sprite_index) - 90;
var ind_x = x;

var spr = (owner_player == 1)
    ? spr_indicator_1
    : spr_indicator_2;

draw_sprite(spr, 0, ind_x, ind_y);

// =====================================================
// PLAYER BARS (DYNAMIC ROOM)
// =====================================================

// Only draw the small floating bars if we are NOT in the arena!
if (room != rm_arena) {

    // =====================
    // PLAYER BARS (FIXED WIDTH)
    // =====================
    var fixed_bar_w = 60; // Change this to make BOTH bars wider or narrower together
    var bar_h = 4;

    // Center the UI above the player based on our fixed width
    var bx = x - (fixed_bar_w / 2);
    var by = y - 70;

    // --- SAFETY MATH ---
    var hp_percent = clamp(hp / max(1, max_hp), 0, 1);
    var armor_percent = 0; 
    if (max_armor > 0) {
        armor_percent = clamp(armor / max_armor, 0, 1);
    }

    // =====================
    // ARMOR BAR (TOP)
    // =====================
    if (max_armor > 0) {
        draw_set_color(c_gray);
        draw_rectangle(bx, by, bx + fixed_bar_w, by + bar_h, false);

        draw_set_color(c_aqua);
        draw_rectangle(bx, by, bx + (fixed_bar_w * armor_percent), by + bar_h, false);
    }

    // =====================
    // HP BAR (BOTTOM)
    // =====================
    draw_set_color(c_black);
    draw_rectangle(bx, by + 6, bx + fixed_bar_w, by + 6 + bar_h, false);

    draw_set_color(c_lime);
    draw_rectangle(bx, by + 6, bx + (fixed_bar_w * hp_percent), by + 6 + bar_h, false);

    draw_set_color(c_white); // Always reset at the end!
    
} // <--- END OF ROOM CHECK
