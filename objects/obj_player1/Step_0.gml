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

if (!variable_instance_exists(id, "initialized")) initialized = false;


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

if (hitstun_timer > 0) {
    hitstun_timer--;

    x += knockback_hsp;
    y += knockback_vsp;

    knockback_hsp *= 0.8;
    knockback_vsp *= 0.8;

    exit;
}


// =====================================================
// 4. SAFE CHARACTER INIT
// =====================================================
if (!initialized && is_struct(character_data)) {
    hp = character_data.hp;
    move_speed = character_data.speed;
    initialized = true;
}


// =====================================================
// 5. DOUBLE TAP DETECTION (ATTACK BUFFER)
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

var attack_pressed = false;

if (last_move_timer > 0) last_move_timer--;
else {
    last_move_count = 0;
    last_move_key = -1;
}

if (move_key != -1) {
    if (last_move_timer > 0 && last_move_key == move_key) {
        last_move_count++;

        if (last_move_count >= 2) {
            attack_pressed = true;
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
// 6. MOVEMENT SYSTEM
// =====================================================
var h = 0;
var v = 0;


// =====================
// PLATFORM MODE (rm_arena)
// =====================
if (room == rm_arena) {

    var jump_pressed = false;

    if (owner_player == 1) {
        h = keyboard_check(ord("D")) - keyboard_check(ord("A"));
        if (keyboard_check_pressed(ord("W"))) jump_pressed = true;
    } else {
        h = keyboard_check(vk_right) - keyboard_check(vk_left);
        if (keyboard_check_pressed(vk_up)) jump_pressed = true;
    }

    // gravity
    vsp += grav;

    if (jump_pressed && on_ground) {
        vsp = -10;
        on_ground = false;
    }

    var input_speed = move_speed;

    // horizontal move
    var nx = x + h * input_speed;
    if (!place_meeting(nx, y, obj_wall_segment)) x = nx;

    // vertical move
    var ny = y + vsp;

    if (place_meeting(x, ny, obj_wall_segment)) {
        while (!place_meeting(x, y + sign(vsp), obj_wall_segment)) {
            y += sign(vsp);
        }
        vsp = 0;
        on_ground = true;
    } else {
        y = ny;
        on_ground = false;
    }
}


// =====================
// TOP DOWN MODE (rm_crawler)
// =====================
else {

    if (owner_player == 1) {
        h = keyboard_check(ord("D")) - keyboard_check(ord("A"));
        v = keyboard_check(ord("S")) - keyboard_check(ord("W"));
    } else {
        h = keyboard_check(vk_right) - keyboard_check(vk_left);
        v = keyboard_check(vk_down) - keyboard_check(vk_up);
    }

    var input_speed = move_speed;

    var nx = x + h * input_speed;
    var ny = y + v * input_speed;

    if (!place_meeting(nx, y, obj_wall_segment)) x = nx;
    if (!place_meeting(x, ny, obj_wall_segment)) y = ny;
}


// =====================================================
// 7. FACING
// =====================================================
if (h != 0) image_xscale = sign(h);

if (h != 0 || v != 0) {
    facing_dir = point_direction(0, 0, h, v);
}


// =====================================================
// 8. SWAP SYSTEM
// =====================================================
var pressed = false;

if (swap_cooldown <= 0) {
    if (owner_player == 1 && keyboard_check_pressed(ord("Q"))) pressed = true;
    if (owner_player == 2 && keyboard_check_pressed(vk_control)) pressed = true;
}

if (pressed) {

    var pickup = instance_nearest(x, y, obj_weapon_pickup);

    if (pickup != noone && point_distance(x, y, pickup.x, pickup.y) < 40) {

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
// 9. WEAPON RESOLVE
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
// 10. ATTACK LOGIC
// =====================================================
if (attack_pressed && attack_cooldown <= 0) {

    attack_cooldown = cooldown;

    if (active_weapon_type == "melee") {

        var hit = collision_circle(
            x + lengthdir_x(10, facing_dir),
            y + lengthdir_y(10, facing_dir),
            range,
            obj_damageable,
            false,
            true
        );

        if (hit != noone && hit.state != "dead") {

            with (hit) {

                var dmg = other.damage;

                if (!variable_instance_exists(id, "armor")) armor = 0;
                if (!variable_instance_exists(id, "hp")) hp = 1;

                // armor first
                if (armor > 0) {
                    var absorbed = min(armor, dmg);
                    armor -= absorbed;
                    dmg -= absorbed;
                }

                // hp damage
                if (dmg > 0) hp -= dmg;

                // knockback
                var dir = point_direction(other.x, other.y, x, y);

                knockback_hsp = lengthdir_x(6, dir);
                knockback_vsp = lengthdir_y(4, dir);

                hitstun_timer = 10;
                hurt_timer = 10;
            }
        }

    } else {

        var proj = instance_create_layer(
            x + lengthdir_x(20, facing_dir),
            y + lengthdir_y(20, facing_dir),
            "Instances",
            obj_projectile
        );

        proj.direction = facing_dir;
        proj.speed = 10;
        proj.damage = damage;
        proj.weapon_data = current_weapon_data;
    }
}


// =====================================================
// 11. HURT FLASH
// =====================================================
if (hurt_timer > 0) {
    hurt_timer--;
    image_blend = c_red;
} else {
    image_blend = c_white;
}