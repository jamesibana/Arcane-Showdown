// =====================================================
// 0. SAFETY INIT (ALWAYS FIRST)
// =====================================================
if (!variable_instance_exists(id, "attack_startup_timer")) attack_startup_timer = 0;
if (!variable_instance_exists(id, "state")) state = "alive";

if (!variable_instance_exists(id, "vsp")) vsp = 0;
if (!variable_instance_exists(id, "grav")) grav = 1.2;
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

if (!variable_instance_exists(id, "clash_timer")) clash_timer = 0;
if (!variable_instance_exists(id, "current_attack_type")) current_attack_type = "";

// 🟢 NEW: Poison and Speed Calculator variables initialized safely here!
if (!variable_instance_exists(id, "poison_timer")) poison_timer = 0;
if (!variable_instance_exists(id, "poison_tick")) poison_tick = 0;
if (!variable_instance_exists(id, "poison_damage")) poison_damage = 100;
if (!variable_instance_exists(id, "poison_slow_mult")) poison_slow_mult = 1;
if (!variable_instance_exists(id, "in_poison_ring")) in_poison_ring = false;


// =====================================================
// HIT PAUSE FREEZE
// =====================================================
if (global.hitpause > 0) {
    image_speed = 0; // Completely freeze the sprite animation!
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
    
    if (image_alpha <= 0) {
        if (room == rm_arena) {
            image_alpha = 0; // 🛑 IN ARENA: Stay invisible, wait for the round to reset!
        } else {
            instance_destroy(); // 🗑️ IN CRAWLER: Destroy normally
        }
    }
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
else array_resize(input_seq, 0); 

if (clash_timer > 0) clash_timer--; 

// =====================================================
// 4. HITSTUN (OVERRIDES CONTROL)
// =====================================================
if (hitstun_timer > 0) {

    attack_startup_timer = 0; // Cancel attack wind-up if hit!
    hitstun_timer--;

    // Horizontal Knockback
    if (place_meeting(x + knockback_hsp, y, obj_wall_segment)) {
        while (!place_meeting(x + sign(knockback_hsp), y, obj_wall_segment)) {
            x += sign(knockback_hsp);
        }
        knockback_hsp = 0; 
    } else {
        x += knockback_hsp;
    }

    // Vertical Knockback
    if (place_meeting(x, y + knockback_vsp, obj_wall_segment)) {
        while (!place_meeting(x, y + sign(knockback_vsp), obj_wall_segment)) {
            y += sign(knockback_vsp);
        }
        knockback_vsp = 0; 
    } else {
        y += knockback_vsp;
    }

    knockback_hsp *= 0.8;
    knockback_vsp *= 0.8;

    exit; 
}

// =====================================================
// 5. SAFE CHARACTER INIT
// =====================================================
if (!initialized && is_struct(character_data)) {
    hp = character_data.hp;
    max_hp = character_data.hp; 
    move_speed = character_data.speed;
    
    if (variable_struct_exists(character_data, "armor")) {
        armor = character_data.armor; 
        max_armor = character_data.armor; 
    } else {
        armor = 0; 
        max_armor = 0;
    }
    
    sprite = character_data.sprite;
    spr_move = character_data.spr_move;
    spr_jump = character_data.spr_jump;
    spr_combo = character_data.spr_combo;
	spr_attack = character_data.spr_attack;
    sprite_index = sprite; 
    
    // 📍 NEW: CAPTURE ENTRY STATS FOR ROUND RESETS
    start_x = x;
    start_y = y;
    entry_armor = armor; // Saves whatever armor they walked into the arena with!
    
    initialized = true;
}

// =====================================================
// 5.5 ARENA ENTRY CAPTURE (THE FIX)
// =====================================================
if (room == rm_arena && !variable_instance_exists(id, "arena_armor_saved")) {
    
    // Take a snapshot of whatever armor they brought into the room!
    entry_armor = armor; 
    
    // Mark it as saved so we don't accidentally overwrite it during the round
    arena_armor_saved = true; 
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
// 6.5 COMBO SEQUENCE TRACKER
// =====================================================
var seq_key = "";

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
    input_seq_timer = 45; 

    var len = array_length(input_seq);
    if (len >= 3) {
        if (input_seq[len-3] == "side" && input_seq[len-2] == "up" && input_seq[len-1] == "down") {
            if (room == rm_arena && active_weapon_type == "melee") {
                combo_buffer = 6; 
            }
            array_resize(input_seq, 0); 
        }
    }
}

// =====================================================
// 7. MOVEMENT
// =====================================================
var h = 0;
var v = 0;

// 🐌 DYNAMIC SPEED CALCULATOR
// Safely initialize flags in case the player hasn't been hit yet
if (!variable_instance_exists(id, "poison_slow_mult")) poison_slow_mult = 1;
if (!variable_instance_exists(id, "in_poison_ring")) in_poison_ring = false;

// Start with the character's base speed
var active_speed = move_speed; 

// Apply Projectile Gas Slowdown
if (poison_timer > 0) {
    active_speed *= poison_slow_mult; 
}
// Apply Arena Ring Slowdown (Stacks with poison gas!)
if (in_poison_ring) {
    active_speed *= 0.5; 
}


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
    
    // Block movement before the round starts or after it ends
    if (room == rm_arena && (!global.round_active || global.round_over)) {
        h = 0;
        jump_pressed = false;
    }

    // 1. Execute Jump first
    if (jump_pressed && on_ground) {
        vsp = -14;
        on_ground = false; 
    }

    // 2. Apply Gravity
    vsp += grav;

    // 3. Horizontal Movement (👇 USING ACTIVE SPEED)
    var nx = x + h * active_speed;
    if (!place_meeting(nx, y, obj_wall_segment)) x = nx;

    // 4. Vertical Movement & Ground Check
    var ny = y + vsp;

    if (place_meeting(x, ny, obj_wall_segment)) {
        while (!place_meeting(x, y + sign(vsp), obj_wall_segment)) {
            y += sign(vsp);
        }
        if (vsp > 0) on_ground = true;
        vsp = 0;
    } else {
        y = ny;
        on_ground = false; 
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

    // 👇 USING ACTIVE SPEED
    var nx = x + h * active_speed;
    var ny = y + v * active_speed;

    if (!place_meeting(nx, y, obj_wall_segment)) x = nx;
    if (!place_meeting(x, ny, obj_wall_segment)) y = ny;
}

// =====================================================
// 8. FACING & SCALING (HITBOX FIX)
// =====================================================
var scale_mult = (room == rm_arena) ? 2 : 1;

// Apply facing direction AND the scale multiplier to the built-in variables!
if (h != 0) {
    image_xscale = sign(h) * scale_mult;
} else {
    // If not moving, ensure we stay scaled but keep our current facing direction
    image_xscale = sign(image_xscale == 0 ? 1 : image_xscale) * scale_mult; 
}

image_yscale = 1 * scale_mult;

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

if (room == rm_arena && (!global.round_active || global.round_over)) pressed = false;

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
// 11. ATTACK (REVERTED TO TIMER-BASED WINDUP)
// =====================================================
var can_attack = true;
if (room == rm_arena && (!global.round_active || global.round_over)) can_attack = false;

// --- PHASE 1: WIND-UP ---
if (can_attack && (attack_buffer > 0 || combo_buffer > 0) && attack_cooldown <= 0) {

    var is_combo = (combo_buffer > 0); 
    
    attack_buffer = 0;
    combo_buffer = 0;
    
    // ⚙️ THE FIX: Adjustable Combo Cooldown Multiplier!
    var combo_cooldown_multiplier = 2; // 👈 Change this number to tweak the penalty!
    
    // Apply the penalty ONLY to melee combos
    if (is_combo && active_weapon_type == "melee") {
        attack_cooldown = cooldown * combo_cooldown_multiplier;
    } else {
        attack_cooldown = cooldown; // Normal attacks and ranged weapons use base cooldown
    }

    clash_timer = 120; 
    current_attack_type = is_combo ? "combo" : "normal";
    
    image_index = 0; 
    
    // Set the Windup Timer
    attack_startup_timer = is_combo ? 10 : 4; 
}

// --- PHASE 2: THE ACTIVE HITBOX ---
if (attack_startup_timer > 0) {
    attack_startup_timer--;
    
    if (attack_startup_timer == 0) {
        
        var is_combo = (current_attack_type == "combo");
        
        // 🎯 THE FIX: Check if greater than 0 instead of exactly equal to 1!
        var aim_dir = (room == rm_arena) ? ((image_xscale > 0) ? 0 : 180) : facing_dir;

        var scale_mult = (room == rm_arena) ? 2 : 1;

        // ---------- MELEE ----------
        if (active_weapon_type == "melee") {
            
            var actual_damage = damage;
            if (is_combo && variable_struct_exists(current_weapon_data, "combo")) {
                actual_damage = current_weapon_data.combo;
            }

            // 🛑 1. Create our hit confirm flag!
            var hit_successful = false; 

            // ⚔️ HITBOX FIX: Multiply offsets and range by the scale_mult!
            var hit = collision_circle(
                x + lengthdir_x(20 * scale_mult, aim_dir), 
                y + lengthdir_y(20 * scale_mult, aim_dir),
                range * scale_mult, // Giant sword = Giant hitbox!
                obj_damageable,
                false,
                true
            );

            if (hit != noone && hit.id != id && hit.state != "dead") {
                
                var can_hurt = true;
                if (hit.object_index == obj_player1 && room != rm_arena) can_hurt = false;

                if (can_hurt) {
                    
                    // 🛑 2. We hit a valid target! Flip the flag to true!
                    hit_successful = true; 
                    
                    var p_dmg = actual_damage; 
                    var p_dir = aim_dir; 
                    var p_scale = image_xscale;
                    
                    with (hit) {
                        if (!variable_instance_exists(id, "armor")) armor = 0;
                        if (!variable_instance_exists(id, "hp")) hp = 1;

                        var is_clash = false;
                        var target_clash = 0;
                        var target_attack_type = "";

                        if (variable_instance_exists(id, "clash_timer")) {
                            target_clash = clash_timer;
                            target_attack_type = current_attack_type;
                        }

                        if (target_clash > 0) {
                            if (is_combo || target_attack_type == "combo") {
                                is_clash = true;
                            }
                        }

                        // ==========================================
                        // RESOLVE CLASH
                        // ==========================================
                        if (is_clash) {
                            p_dmg = 0;
                            clash_timer = 0;
                            other.clash_timer = 0;

                            global.hitpause = 15;
							
							// ==========================================
                            // 🔊 NEW: DELAYED CLASH SOUND!
                            // ==========================================
                            // ⚙️ ADJUST THIS: How many frames to wait before the sound plays
                            var sound_delay_frames = 5; 

                            if (sound_delay_frames <= 0) {
                                // Play instantly if delay is 0
                                var clash_snd = audio_play_sound(snd_block, 1, false); 
                                audio_sound_pitch(clash_snd, random_range(0.8, 1.1));
                            } else {
                                // Tell GameMaker to wait, and THEN play the sound!
                                call_later(sound_delay_frames, time_source_units_frames, function() {
                                    var clash_snd = audio_play_sound(snd_block, 1, false); 
                                    audio_sound_pitch(clash_snd, random_range(0.8, 1.1));
                                });
                            }
                            // ==========================================

                            knockback_hsp = lengthdir_x(15, p_dir); 
                            knockback_vsp = lengthdir_y(8, p_dir);
                            hitstun_timer = 20;
                            hurt_timer = 20;

                            other.knockback_hsp = lengthdir_x(15, p_dir + 180); 
                            other.knockback_vsp = lengthdir_y(8, p_dir + 180);
                            other.hitstun_timer = 20;
                            other.hurt_timer = 20;

                            var fx_x = ((x + other.x) / 2) - 60;
                            var fx_y = ((y + other.y) / 2) - 120; 
                            
                            var fx = instance_create_layer(fx_x, fx_y, "Instances", obj_combo_effect);
                            fx.sprite_index = spr_block; 
                            
                            // 💥 MAKE IT MASSIVE
                            fx.image_xscale = 3; 
                            fx.image_yscale = 3;
                            
                            // 🐌 MAKE IT LAST LONGER
                            fx.image_speed = 0.075; 
                            
                            // 🎨 TINT THE GLOW
                            fx.image_blend = c_yellow; 
                            
                            // 🎲 RANDOM ROTATION
                            fx.image_angle = random_range(-25, 25);

                        } 
                        // ==========================================
                        // RESOLVE NORMAL DAMAGE
                        // ==========================================
                        else {
                            if (armor > 0) {
                                var absorbed = min(armor, p_dmg);
                                armor -= absorbed;
                                p_dmg -= absorbed;
                            }

                            if (p_dmg > 0) hp -= p_dmg;

                            if (is_combo) {
                                knockback_hsp = lengthdir_x(10, p_dir); 
                                knockback_vsp = lengthdir_y(6, p_dir);
                                
                                hitstun_timer = 15;
                                hurt_timer = 15;
                                global.hitpause = 12; 
                                
                                var fx_x = x - lengthdir_x(10, p_dir) + 15;
                                var fx_y = y - lengthdir_y(10, p_dir) - 50;
                                
                                var fx = instance_create_layer(fx_x, fx_y, "Instances", obj_combo_effect);
                                fx.image_xscale = p_scale * 2; 
                                fx.image_yscale = p_scale * 2;
                                
                                fx.sprite_index = Anim_Slash_Melee; 
                                
                                if (variable_struct_exists(other.current_weapon_data, "combo_fx")) {
                                    fx.sprite_index = other.current_weapon_data.combo_fx;
                                }
                            } else {
                                knockback_hsp = lengthdir_x(6, p_dir);
                                knockback_vsp = lengthdir_y(4, p_dir);
                                
                                hitstun_timer = 10;
                                hurt_timer = 10;
                                global.hitpause = 6; 
                            }
                        }
                    }
                }
            }

            // ==========================================
            // 🔊 3. PLAY SOUNDS BASED ON HIT FLAG
            // ==========================================
            // Plays the heavy combo sound ONLY if it connected with flesh!
            if (is_combo && hit_successful) {
                var snd = audio_play_sound(snd_combo, 1, false);
                audio_sound_pitch(snd, random_range(0.85, 1.0)); // Slightly deeper for impact
            } else {
                // Unique Normal Weapon Sound (plays for normal hits AND missed combos!)
                if (variable_struct_exists(current_weapon_data, "attack_sound")) {
                    var snd = audio_play_sound(current_weapon_data.attack_sound, 1, false);
                    audio_sound_pitch(snd, random_range(0.9, 1.1)); 
                }
            }

        }
        // ---------- RANGED ----------
        else {
            // 🏹 HITBOX FIX: Shoot from the giant's chest, not their knees!
            var spawn_y = y - (45 * scale_mult); 
            
            var proj = instance_create_layer(
                x + lengthdir_x(20 * scale_mult, aim_dir),
                spawn_y + lengthdir_y(20 * scale_mult, aim_dir), 
                "Instances",
                obj_projectile
            );

            proj.direction = aim_dir;
            proj.speed = 10;
            proj.damage = damage;
            proj.weapon_data = current_weapon_data;
            proj.owner_id = id;
            proj.owner_player = owner_player;
            
            // ==========================================
            // 🔊 PLAY THE SHOOTING SOUND!
            // ==========================================
            if (variable_struct_exists(current_weapon_data, "shoot_sound")) {
                var snd = audio_play_sound(current_weapon_data.shoot_sound, 1, false);
                // Slightly randomize the pitch between 0.9 (deeper) and 1.1 (higher)
                audio_sound_pitch(snd, random_range(0.9, 1.1)); 
            }
            
            // Scale the bullet up too so it doesn't look like a tiny pebble!
            proj.image_xscale = scale_mult;
            proj.image_yscale = scale_mult;
        }
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
// 14. ANIMATION RESOLUTION & SPEED RECOVERY
// =====================================================
if (state == "alive") {
    
    // 1. Attack Animation
    if (attack_cooldown > 0) {
        
        // 🗡️ Differentiate between Combo and Normal Attack sprites
        if (current_attack_type == "combo") {
            sprite_index = spr_combo;
        } else {
            sprite_index = spr_attack; 
        }
        
        var total_frames = sprite_get_number(sprite_index);
        var impact_frame = floor(total_frames / 2); 
        
        var windup_speed = 1.0; 
        var follow_speed = 1.0; 

        // 🎯 CLASS-SPECIFIC EASING
        if (current_attack_type == "combo") {
            switch (sprite_index) {
                case Anim_Combo_Knight:
                    windup_speed = 3.2; 
                    follow_speed = 0.8; 
                    break;
                case Anim_Combo_Assassin:
                    windup_speed = 5.48; 
                    follow_speed = 0.45; 
                    break;
                case Anim_Combo_Colossus:
                    windup_speed = 9.6; 
                    follow_speed = 2.1; 
                    break;
                case Anim_Combo_Warlock:
                    windup_speed = 2.25; 
                    follow_speed = 0.4; 
                    break;
            }
        } else {
            windup_speed = 1.5;
            follow_speed = 0.8;
        }
        
        // 🛑 FIXED VISUAL DURATION
        // Animation will always complete in exactly this many frames!
        var visual_duration = 20; 
        var base_speed = total_frames / visual_duration; 
        
        if (image_index < impact_frame) {
            image_speed = base_speed * windup_speed;
        } else {
            image_speed = base_speed * follow_speed;
        }
        
        // 🛑 PREVENT LOOPING & HOLD THE POSE
        if (image_index >= total_frames - 1) {
            image_index = total_frames - 1;
            image_speed = 0;
        }
    }
    // 2. Normal Movement
    else {
        image_speed = 1; 

        // 🏃 SPEED RECOVERY: Clear poison/hitstun slows
        if (hitstun_timer <= 0 && poison_timer <= 0) {
             move_speed = character_data.speed;
        }

        if (room == rm_arena) {
            if (!on_ground) {
                sprite_index = spr_jump;
            } else if (h != 0) {
                sprite_index = spr_move;
            } else {
                sprite_index = sprite; 
            }
        } 
        else {
            if (h != 0 || v != 0) {
                sprite_index = spr_move;
            } else {
                sprite_index = sprite;
            }
        }
    }
}
