
// ============================
// DRAW PLAYER WITH Y-OFFSET
// ============================
// Adjust this number until the feet sit perfectly on the floor!
var y_offset = 32; 

draw_sprite_ext(
    sprite_index, 
    image_index, 
    x, 
    y - y_offset,  // Shifts the art UP without moving the collision box
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

// =====================
// PLAYER BARS
// =====================

// bar settings
var bar_w = 40;
var bar_h = 4;

// position above player
var bx = x - bar_w / 2;
var by = y - 70;

// =====================
// ARMOR BAR (TOP)
// =====================
draw_set_color(c_gray);
draw_rectangle(bx, by, bx + bar_w, by + bar_h, false);

draw_set_color(c_aqua);
draw_rectangle(bx, by, bx + (bar_w * (armor / max_armor)), by + bar_h, false);

// =====================
// HP BAR (BOTTOM)
// =====================
draw_set_color(c_black);
draw_rectangle(bx, by + 6, bx + bar_w, by + 6 + bar_h, false);

draw_set_color(c_lime);
draw_rectangle(bx, by + 6, bx + (bar_w * (hp / max_hp)), by + 6 + bar_h, false);

draw_set_color(c_white);