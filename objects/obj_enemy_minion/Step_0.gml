// =====================================================
// SAFETY INIT
// =====================================================
if (!variable_instance_exists(id, "state")) state = "alive";
if (!variable_instance_exists(id, "hurt_timer")) hurt_timer = 0;
if (!variable_instance_exists(id, "poison_timer")) poison_timer = 0;
if (!variable_instance_exists(id, "poison_tick")) poison_tick = 0;


// =====================================================
// 💀 DEATH TRIGGER (ONLY ONCE)
// =====================================================
if (hp <= 0 && state != "dead") {

    state = "dead";

    image_speed = 0;
    image_alpha = 1;
    image_blend = c_red;

    death_fall_speed = -2;
    death_rotation_speed = 8;

    exit;
}


// =====================================================
// 💀 DEATH STATE (NO OTHER LOGIC RUNS)
// =====================================================
if (state == "dead") {

    image_angle += death_rotation_speed;
    y += death_fall_speed;
    death_fall_speed += 0.3;

    image_alpha -= 0.03;

    if (image_alpha <= 0) {
        instance_destroy();
    }

    exit;
}


// =====================================================
// ❤️ HURT FLASH (ALIVE ONLY)
// =====================================================
if (hurt_timer > 0) {
    hurt_timer--;
    image_blend = c_red;
} else {
    image_blend = c_white;
}


// =====================================================
// 🧠 TARGET + DISTANCES
// =====================================================
var target = instance_nearest(x, y, obj_player1);

var dist_to_player = 999999;
if (target != noone) {
    dist_to_player = point_distance(x, y, target.x, target.y);
}

var dist_from_home = point_distance(x, y, home_x, home_y);


// =====================================================
// 🧭 STATE SWITCHING
// =====================================================
if (state == "alive") {

    if (dist_to_player <= aggro_enter) {
        state = "chase";
    }
}

if (state == "chase") {
    
    target = instance_nearest(x, y, obj_player1);

    if (target != noone) {

        var dist = point_distance(x, y, target.x, target.y);

        // 🛑 NEW: Triggers the attack state instead of instant damage!
        if (dist < attack_range) {
            if (attack_cooldown <= 0) {
                state = "attack";
                sprite_index = spr_attack;
                image_index = 0;
                damage_dealt = false;
            }
        }
    }

    attack_cooldown--;

    if (dist_to_player > aggro_exit) {
        state = "return";
    }
}

// ⚔️ NEW: THE ATTACK STATE
if (state == "attack") {
    
    // 1. Stop moving while attacking!
    hsp = 0;
    vsp = 0;
    
    // 2. Deal damage on the specific hit frame
    if (floor(image_index) == attack_hit_frame && !damage_dealt) {
        
        target = instance_nearest(x, y, obj_player1);
        
        // Double check the player hasn't run away during the wind-up!
        if (target != noone && point_distance(x, y, target.x, target.y) <= attack_range + 10) {
            with (target) {
                var dmg = other.attack_damage;
                if (!variable_instance_exists(id, "armor")) armor = 0;
                if (!variable_instance_exists(id, "hp")) hp = 1;

                // 🛑 Save the damage before armor eats it!
                var dmg_to_show = dmg;

                if (armor > 0) {
                    var absorbed = min(armor, dmg);
                    armor -= absorbed;
                    dmg -= absorbed;
                }
                
                if (dmg > 0) {
                    hp -= dmg; 
                }
                
                // 🛑 SPAWN THE TEXT (EXACTLY ONCE!)
                if (dmg_to_show > 0) {
                    var float_x = x + random_range(-15, 15);
                    var float_y = y - 70; // High up so it clears the player sprite
                    
                    var float_text = instance_create_layer(float_x, float_y, "Instances", obj_damage_indicator);
                    float_text.damage = dmg_to_show;
                    float_text.color = c_yellow; 
                }

                hurt_timer = 10;
            }
        }
        
        damage_dealt = true; // Mark as hit so it doesn't trigger again next frame
    }
    
    // 3. End the attack when the animation finishes
    if (image_index >= image_number - 1) {
        state = "chase";
        attack_cooldown = attack_speed;
    }
}

if (state == "return") {

    if (dist_from_home <= 2) {
        state = "alive";
    }
}


// =====================================================
// 🚶 MOVEMENT & ANIMATION
// =====================================================
var hsp = 0;
var vsp = 0;

if (state == "chase" && target != noone) {
    var dir = point_direction(x, y, target.x, target.y);
    hsp = lengthdir_x(move_speed, dir);
    vsp = lengthdir_y(move_speed, dir);
}

if (state == "return") {
    var dir = point_direction(x, y, home_x, home_y);
    hsp = lengthdir_x(move_speed, dir);
    vsp = lengthdir_y(move_speed, dir);
}

// 🛑 NEW: Ensure no movement if attacking or dead
if (state == "attack" || state == "dead") {
    hsp = 0;
    vsp = 0;
}

// 🎬 NEW: SWAP SPRITES BASED ON MOVEMENT
if (state != "attack" && state != "dead") {
    if (hsp != 0 || vsp != 0) {
        sprite_index = spr_walk;
    } else {
        sprite_index = spr_idle;
    }
}

// =====================================================
// 🫧 NEW: SOFT COLLISION (PERSONAL SPACE BUBBLE)
// =====================================================
if (state == "chase" || state == "return") {
    
    // Look for another enemy of this exact same type right where we are standing
    var neighbor = instance_place(x, y, object_index);
    
    if (neighbor != noone && neighbor.id != id) {
        
        // Figure out which way to push away from the neighbor
        var push_dir = point_direction(neighbor.x, neighbor.y, x, y);
        
        // ⚙️ ADJUST THIS: How hard they push each other apart (0.3 to 0.8 is usually best)
        var push_force = 0.5; 
        
        // Gently add the push force to our current movement speed!
        hsp += lengthdir_x(push_force, push_dir);
        vsp += lengthdir_y(push_force, push_dir);
    }
}

// =====================================================
// 🧱 COLLISION MOVE
// =====================================================
if (!place_meeting(x + hsp, y, obj_wall_segment)) x += hsp;
if (!place_meeting(x, y + vsp, obj_wall_segment)) y += vsp;


// =====================================================
// 👀 FACING DIRECTION
// =====================================================
if (hsp != 0) {
    // Because the base sprite faces LEFT:
    // A positive hsp (moving right) becomes -1 (flipped)
    // A negative hsp (moving left) becomes 1 (normal)
    image_xscale = -sign(hsp);
}


// =====================================================
// ☠️ POISON DAMAGE
// =====================================================
if (poison_timer > 0) {

    poison_timer--;
    poison_tick++;

    if (poison_tick >= 15) {

        hp -= poison_damage;
        hurt_timer = 10;

        poison_tick = 0;
    }
}