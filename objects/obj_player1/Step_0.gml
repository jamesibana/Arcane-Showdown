// =====================================================
// 0. SAFETY INIT (ALWAYS FIRST)
// =====================================================
if (!variable_instance_exists(id, "state")) state = "alive";

if (!variable_instance_exists(id, "vsp")) vsp = 0;
if (!variable_instance_exists(id, "grav")) grav = 0.4;
if (!variable_instance_exists(id, "on_ground")) on_ground = false;

if (!variable_instance_exists(id, "hurt_timer")) hurt_timer = 0;
if (!variable_instance_exists(id, "attack_cooldown")) attack_cooldown = 0;
if (!variable_instance_exists(id, "swap_cooldown")) swap_cooldown = 0;

if (!variable_instance_exists(id, "hitstun_timer")) hitstun_timer = 0;
if (!variable_instance_exists(id, "knockback_hsp")) knockback_hsp = 0;
if (!variable_instance_exists(id, "knockback_vsp")) knockback_vsp = 0;

if (!variable_instance_exists(id, "attack_buffer")) attack_buffer = 0;
if (!variable_instance_exists(id, "initialized")) initialized = false;

if (!variable_instance_exists(id, "input_seq")) input_seq = [];
if (!variable_instance_exists(id, "input_seq_timer")) input_seq_timer = 0;
if (!variable_instance_exists(id, "combo_buffer")) combo_buffer = 0;


// =====================================================
// HIT PAUSE FREEZE
// =====================================================
if (global.hitpause > 0) {

    // allow only visual effects during pause
    if (hurt_timer > 0) hurt_timer--;

    exit;
}

// =====================================================
// 1. DEATH TRIGGER
// =====================================================
if (hp <= 0 && state != "dead") {
    state = "dead";

    attack_cooldown = 0;
    swap_cooldown = 0;
    vsp = 0;

    image_speed = 0;
    image_blend = c_red;
}


// =====================================================
// 2. DEATH STATE
// =====================================================
if (state == "dead") {

    vsp = 0;
    image_alpha -= 0.05;
    image_angle += 5;

    if (image_alpha <= 0) instance_destroy();
    exit;
}


// =====================================================
// 3. TIMERS
// =====================================================
if (attack_cooldown > 0) attack_cooldown--;
if (swap_cooldown > 0) swap_cooldown--;
if (attack_buffer > 0) attack_buffer--;

if (combo_buffer > 0) combo_buffer--;
if (input_seq_timer > 0) input_seq_timer--;
else array_resize(input_seq, 0); // Clear the sequence if they stop pressing keys

// =====================================================
// 4. HITSTUN (OVERRIDES CONTROL)
// =====================================================
if (hitstun_timer > 0) {

    hitstun_timer--;

    // Horizontal Knockback Collision
    if (place_meeting(x + knockback_hsp, y, obj_wall_segment)) {
        // Scoot flush against the wall
        while (!place_meeting(x + sign(knockback_hsp), y, obj_wall_segment)) {
            x += sign(knockback_hsp);
        }
        knockback_hsp = 0; // Stop horizontal momentum
    } else {
        x += knockback_hsp;
    }

    // Vertical Knockback Collision
    if (place_meeting(x, y + knockback_vsp, obj_wall_segment)) {
        // Scoot flush against the wall
        while (!place_meeting(x, y + sign(knockback_vsp), obj_wall_segment)) {
            y += sign(knockback_vsp);
        }
        knockback_vsp = 0; // Stop vertical momentum
    } else {
        y += knockback_vsp;
    }

    // Friction decay
    knockback_hsp *= 0.8;
    knockback_vsp *= 0.8;

    exit; // Continues to override standard movement}
}

// =====================================================
// 5. SAFE CHARACTER INIT
// =====================================================
if (!initialized && is_struct(character_data)) {
    hp = character_data.hp;
    move_speed = character_data.speed;
    
    // --- NEW: Load specific character animations ---
    sprite = character_data.sprite;
	
	spr_move = character_data.spr_move;
    spr_jump = character_data.spr_jump;
    spr_combo = character_data.spr_combo;
    
    // Set the initial starting sprite
    sprite_index = sprite; 
    
    initialized = true;
}


// =====================================================
// 6. DOUBLE TAP → ATTACK BUFFER
// =====================================================
var move_key = -1;

if (owner_player == 1) {
    if (keyboard_check_pressed(ord("W"))) move_key = ord("W");
    else if (keyboard_check_pressed(ord("A"))) move_key = ord("A");
    else if (keyboard_check_pressed(ord("S"))) move_key = ord("S");
    else if (keyboard_check_pressed(ord("D"))) move_key = ord("D");
} else {
    if (keyboard_check_pressed(vk_up)) move_key = vk_up;
    else if (keyboard_check_pressed(vk_left)) move_key = vk_left;
    else if (keyboard_check_pressed(vk_down)) move_key = vk_down;
    else if (keyboard_check_pressed(vk_right)) move_key = vk_right;
}

if (last_move_timer > 0) last_move_timer--;
else {
    last_move_count = 0;
    last_move_key = -1;
}

if (move_key != -1) {

    if (last_move_timer > 0 && last_move_key == move_key) {

        last_move_count++;

        if (last_move_count >= 2) {
            attack_buffer = 6;
            last_move_count = 0;
            last_move_timer = 0;
        }

    } else {
        last_move_count = 1;
        last_move_key = move_key;
    }

    last_move_timer = 15;
}

// =====================================================
// 6.5 COMBO SEQUENCE TRACKER (Side -> Up -> Down)
// =====================================================
var seq_key = "";

// Detect directional inputs for the combo tracker
if (owner_player == 1) {
    if (keyboard_check_pressed(ord("D")) || keyboard_check_pressed(ord("A"))) seq_key = "side";
    else if (keyboard_check_pressed(ord("W"))) seq_key = "up";
    else if (keyboard_check_pressed(ord("S"))) seq_key = "down";
} else {
    if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(vk_left)) seq_key = "side";
    else if (keyboard_check_pressed(vk_up)) seq_key = "up";
    else if (keyboard_check_pressed(vk_down)) seq_key = "down";
}

if (seq_key != "") {
    array_push(input_seq, seq_key);
    input_seq_timer = 45; // They have roughly half a second to press the next key

    var len = array_length(input_seq);
    
    // Check if the last 3 inputs match the combo
    if (len >= 3) {
        if (input_seq[len-3] == "side" && input_seq[len-2] == "up" && input_seq[len-1] == "down") {
            
            // Only allow in Side View and with Melee weapons
            if (room == rm_arena && active_weapon_type == "melee") {
                combo_buffer = 6; 
            }
            
            array_resize(input_seq, 0); // Clear sequence so they can't spam it
        }
    }
}

// =====================================================
// 7. MOVEMENT
// =====================================================
var h = 0;
var v = 0;


// ---------- SIDE VIEW (ARENA) ----------
if (room == rm_arena) {

    var jump_pressed = false;

    if (owner_player == 1) {
        h = keyboard_check(ord("D")) - keyboard_check(ord("A"));
        if (keyboard_check_pressed(ord("W"))) jump_pressed = true;
    } else {
        h = keyboard_check(vk_right) - keyboard_check(vk_left);
        if (keyboard_check_pressed(vk_up)) jump_pressed = true;
    }

    // 1. Execute Jump first, relying on the 'on_ground' state from the previous frame
    if (jump_pressed && on_ground) {
        vsp = -10;
        on_ground = false; // Instantly register as in the air
    }

    // 2. Apply Gravity
    vsp += grav;

    // 3. Horizontal Movement
    var nx = x + h * move_speed;
    if (!place_meeting(nx, y, obj_wall_segment)) x = nx;

    // 4. Vertical Movement & Ground Check
    var ny = y + vsp;

    if (place_meeting(x, ny, obj_wall_segment)) {
        
        // Scoot flush against the floor/ceiling
        while (!place_meeting(x, y + sign(vsp), obj_wall_segment)) {
            y += sign(vsp);
        }
        
        // If we were falling downwards and hit a surface, we are officially grounded!
        if (vsp > 0) {
            on_ground = true;
        }
        
        vsp = 0;
        
    } else {
        y = ny;
        on_ground = false; // We are in the air (falling or jumping)
    }
}


// ---------- TOP-DOWN (CRAWLER) ----------
else {

    if (owner_player == 1) {
        h = keyboard_check(ord("D")) - keyboard_check(ord("A"));
        v = keyboard_check(ord("S")) - keyboard_check(ord("W"));
    } else {
        h = keyboard_check(vk_right) - keyboard_check(vk_left);
        v = keyboard_check(vk_down) - keyboard_check(vk_up);
    }

    var nx = x + h * move_speed;
    var ny = y + v * move_speed;

    if (!place_meeting(nx, y, obj_wall_segment)) x = nx;
    if (!place_meeting(x, ny, obj_wall_segment)) y = ny;
}


// =====================================================
// 8. FACING
// =====================================================
if (h != 0) image_xscale = sign(h);

if (h != 0 || v != 0) {
    facing_dir = point_direction(0, 0, h, v);
}


// =====================================================
// 9. SWAP SYSTEM
// =====================================================
var pressed = false;

if (swap_cooldown <= 0) {
    if (owner_player == 1 && keyboard_check_pressed(ord("Q"))) pressed = true;
    if (owner_player == 2 && keyboard_check_pressed(vk_control)) pressed = true;
}

if (pressed) {

    var pickup = instance_nearest(x, y, obj_weapon_pickup);

    if (pickup != noone && point_distance(x, y, pickup.x, pickup.y) < 80) {

        var new_key = pickup.weapon_key;
        var new_data = get_weapon(new_key);

        if (new_data != undefined) {

            var new_type = new_data.type;
            var drop_key = (new_type == "melee") ? weapon_melee : weapon_ranged;

            var drop = instance_create_layer(x, y, "Instances", obj_weapon_pickup);
            drop.weapon_key = drop_key;

            var drop_data = get_weapon(drop_key);
            if (drop_data != undefined) drop.weapon_sprite = drop_data.sprite;

            if (new_type == "melee") {
                weapon_melee = new_key;
                weapon_melee_data = new_data;
            } else {
                weapon_ranged = new_key;
                weapon_ranged_data = new_data;
            }

            instance_destroy(pickup);
        }

    } else {
        active_weapon_type = (active_weapon_type == "melee") ? "ranged" : "melee";
    }

    swap_cooldown = 10;
}


// =====================================================
// 10. WEAPON RESOLVE
// =====================================================
var resolved;

if (active_weapon_type == "melee") resolved = weapon_melee_data;
else resolved = weapon_ranged_data;

if (resolved == undefined) {
    resolved = get_weapon("sword");
    weapon_melee_data = resolved;
    active_weapon_type = "melee";
}

current_weapon_data = resolved;

weapon_sprite = resolved.sprite;
damage = resolved.damage;
cooldown = resolved.cooldown;
range = resolved.range;


// =====================================================
// 11. ATTACK
// =====================================================
// Trigger if EITHER a normal attack OR a combo attack is buffered
if ((attack_buffer > 0 || combo_buffer > 0) && attack_cooldown <= 0) {

    var is_combo = (combo_buffer > 0); // Remember if this was a combo!
    
    attack_buffer = 0;
    combo_buffer = 0;
    attack_cooldown = cooldown;

    // ---------- MELEE ----------
    if (active_weapon_type == "melee") {

        // Determine actual damage: Override with combo damage if applicable
        var actual_damage = damage;
        if (is_combo && variable_struct_exists(current_weapon_data, "combo")) {
            actual_damage = current_weapon_data.combo;
        }

        var hit = collision_circle(
            x + lengthdir_x(10, facing_dir),
            y + lengthdir_y(10, facing_dir),
            range,
            obj_damageable,
            false,
            true
        );

      if (hit != noone && hit.id != id && hit.state != "dead") {
            
            var p_dmg = actual_damage; 
            var p_dir = facing_dir;
            var p_scale = image_xscale; // --- NEW: Grab player's visual facing ---

            with (hit) {

                if (!variable_instance_exists(id, "armor")) armor = 0;
                if (!variable_instance_exists(id, "hp")) hp = 1;

                // Armor first
                if (armor > 0) {
                    var absorbed = min(armor, p_dmg);
                    armor -= absorbed;
                    p_dmg -= absorbed;
                }

                if (p_dmg > 0) hp -= p_dmg;

                // ==========================================
                // 💥 HIT EFFECTS: NORMAL vs COMBO
                // ==========================================
				if (is_combo) {
                    // --- HEAVY COMBO HIT ---
                    knockback_hsp = lengthdir_x(10, p_dir); 
                    knockback_vsp = lengthdir_y(6, p_dir);
                    
                    hitstun_timer = 15;
                    hurt_timer = 15;
                    global.hitpause = 12; 
                    
                    // 🎇 VFX SPAWN
                    var fx_x = x - lengthdir_x(10, p_dir) + 15;
                    var fx_y = y - lengthdir_y(10, p_dir) - 50;
                    
                    var fx = instance_create_layer(fx_x, fx_y, "Instances", obj_combo_effect);
                    fx.image_xscale = p_scale * 2; 
					fx.image_yscale = p_scale * 2;
                    
                    // --- NEW: WEAPON-SPECIFIC SPRITE ---
                    // Default fallback sprite just in case the weapon has no combo_fx
                    fx.sprite_index = Anim_Slash_Melee; 
                    
                    // Check if the current weapon has a specific combo effect
                    if (variable_struct_exists(other.current_weapon_data, "combo_fx")) {
                        fx.sprite_index = other.current_weapon_data.combo_fx;
                    }
                    
                } else {
                    // --- NORMAL HIT ---
                    knockback_hsp = lengthdir_x(6, p_dir);
                    knockback_vsp = lengthdir_y(4, p_dir);
                    
                    hitstun_timer = 10;
                    hurt_timer = 10;
                    global.hitpause = 6; 
                }
            }
        }
	}

// ---------- RANGED ----------
else {
    // 1. Define where the "chest/gun" level is visually
    var spawn_y = y - 45; // 'y' is feet, -32 is center, -45 is chest/hands
    
    // 2. Create the projectile at the new height
    var proj = instance_create_layer(
        x + lengthdir_x(20, facing_dir),
        spawn_y + lengthdir_y(20, facing_dir), // Use spawn_y here
        "Instances",
        obj_projectile
    );

    proj.direction = facing_dir;
    proj.speed = 10;
    proj.damage = damage;
    proj.weapon_data = current_weapon_data;

    proj.owner_id = id;
    proj.owner_player = owner_player;
}
}


// =====================================================
// 12. POISON
// =====================================================
if (!variable_instance_exists(id, "poison_timer")) poison_timer = 0;
if (!variable_instance_exists(id, "poison_tick")) poison_tick = 0;
if (!variable_instance_exists(id, "poison_damage")) poison_damage = 100;

if (poison_timer > 0) {

    poison_timer--;
    poison_tick++;

    if (poison_tick >= 15) {

        var dmg = poison_damage;

        if (armor > 0) {
            var absorbed = min(armor, dmg);
            armor -= absorbed;
            dmg -= absorbed;
        }

        if (dmg > 0) hp -= dmg;

        hurt_timer = 10;
        poison_tick = 0;
    }
}


// =====================================================
// 13. HURT FLASH
// =====================================================
if (hurt_timer > 0) {
    hurt_timer--;
    image_blend = c_red;
} else {
    image_blend = c_white;
}

// =====================================================
// 14. ANIMATION RESOLUTION
// =====================================================
if (state == "alive") {
    
    // 1. Attack Animation (Overrides Movement)
    // If the attack is on cooldown, we assume the player is currently swinging/shooting
    if (attack_cooldown > 0) {
        sprite_index = spr_move;
    } 
    // 2. Normal Movement
    else {
        // ---------- SIDE VIEW (ARENA) ----------
        if (room == rm_arena) {
            if (!on_ground) {
                sprite_index = spr_jump;
            } else if (h != 0) {
                sprite_index = spr_move;
            } else {
                sprite_index = sprite; // This maps to your base 'sprite'
            }
        } 
        // ---------- TOP-DOWN (CRAWLER) ----------
        else {
            if (h != 0 || v != 0) {
                sprite_index = spr_move;
            } else {
                sprite_index = sprite;
            }
        }
    }
    
    // Ensure animation plays at normal speed
    image_speed = 1; 
}