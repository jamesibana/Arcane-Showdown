// =====================================================
// 1. TIMERS
// =====================================================
if (attack_cooldown > 0) attack_cooldown--;
if (swap_cooldown > 0) swap_cooldown--;

// =====================================================
// 2. SAFE INIT
// =====================================================
if (!initialized && is_struct(character_data)) {
    hp = character_data.hp;
    move_speed = character_data.speed;
    initialized = true;
}

// =====================================================
// 3. MOVEMENT KEY DETECTION (FOR DOUBLE TAP)
// =====================================================
var move_key = -1;

// PLAYER 1
if (owner_player == 1) {
    if (keyboard_check_pressed(ord("W"))) move_key = ord("W");
    else if (keyboard_check_pressed(ord("A"))) move_key = ord("A");
    else if (keyboard_check_pressed(ord("S"))) move_key = ord("S");
    else if (keyboard_check_pressed(ord("D"))) move_key = ord("D");
}
// PLAYER 2
else {
    if (keyboard_check_pressed(vk_up)) move_key = vk_up;
    else if (keyboard_check_pressed(vk_left)) move_key = vk_left;
    else if (keyboard_check_pressed(vk_down)) move_key = vk_down;
    else if (keyboard_check_pressed(vk_right)) move_key = vk_right;
}

// =====================================================
// 4. DOUBLE TAP ATTACK LOGIC
// =====================================================
var attack_pressed = false;

// timer decay
if (last_move_timer > 0) {
    last_move_timer--;
} else {
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
// 5. MOVEMENT INPUT
// =====================================================
var h = 0;
var v = 0;

if (owner_player == 1) {
    h = keyboard_check(ord("D")) - keyboard_check(ord("A"));
    v = keyboard_check(ord("S")) - keyboard_check(ord("W"));
} else {
    h = keyboard_check(vk_right) - keyboard_check(vk_left);
    v = keyboard_check(vk_down) - keyboard_check(vk_up);
}

/// =====================
/// A. SPRITE FACING (FLIP ONLY)
/// =====================
if (h != 0) {
    image_xscale = sign(h);
}

// =====================================================
// 6. MOVE + COLLISION
// =====================================================
var new_x = x + h * move_speed;
var new_y = y + v * move_speed;

if (!place_meeting(new_x, y, obj_wall_segment)) x = new_x;
if (!place_meeting(x, new_y, obj_wall_segment)) y = new_y;

// =====================================================
// 7. FACING DIRECTION
// =====================================================
if (h != 0 || v != 0) {
    facing_dir = point_direction(0, 0, h, v);
}

// =====================================================
// 8. SWAP INPUT
// =====================================================
var pressed = false;

if (swap_cooldown <= 0) {

    if (owner_player == 1 && keyboard_check_pressed(ord("Q"))) {
        pressed = true;
    }

    if (owner_player == 2 && keyboard_check_pressed(vk_control)) {
        pressed = true;
    }
}

// =====================================================
// 9. PICKUP / SWAP SYSTEM
// =====================================================
if (pressed) {

    var pickup = instance_nearest(x, y, obj_weapon_pickup);
    var has_pickup = (pickup != noone && point_distance(x, y, pickup.x, pickup.y) < 40);

    if (has_pickup) {

        var new_key = pickup.weapon_key;
        var new_data = get_weapon(new_key);

        if (new_data != undefined) {

            var new_type = new_data.type;
            var drop_key;

            // drop correct slot
            if (new_type == "melee") {
                drop_key = weapon_melee;
            } else {
                drop_key = weapon_ranged;
            }

            var drop = instance_create_layer(x, y, "Instances", obj_weapon_pickup);
            drop.weapon_key = drop_key;

            var drop_data = get_weapon(drop_key);
            if (drop_data != undefined) {
                drop.weapon_sprite = drop_data.sprite;
            }

            // replace slot
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
        // toggle weapon type
        active_weapon_type = (active_weapon_type == "melee") ? "ranged" : "melee";
    }

    swap_cooldown = 10;
}

// =====================================================
// 10. RESOLVE ACTIVE WEAPON
// =====================================================
var resolved;

if (active_weapon_type == "melee") {
    resolved = weapon_melee_data;
} else {
    resolved = weapon_ranged_data;
}

// fallback safety
if (resolved == undefined) {
    resolved = get_weapon("sword");
    weapon_melee_data = resolved;
    active_weapon_type = "melee";
}

// apply stats
current_weapon_data = resolved;

weapon_sprite = resolved.sprite;
damage = resolved.damage;
cooldown = resolved.cooldown;
range = resolved.range;

// =====================================================
// 11. ATTACK LOGIC
// =====================================================
if (attack_pressed && attack_cooldown <= 0) {

    attack_cooldown = cooldown;

    if (active_weapon_type == "melee") {

        var hit = instance_place(
            x + lengthdir_x(range, facing_dir),
            y + lengthdir_y(range, facing_dir),
            obj_enemy_parent
        );

        if (hit != noone) {
            with (hit) {
                hp -= other.damage;
				hurt_timer = 10; // short red flash
            }
        }

    } else {

        var spawn_x = x + lengthdir_x(20, facing_dir);
        var spawn_y = y + lengthdir_y(20, facing_dir);

var proj = instance_create_layer(spawn_x, spawn_y, "Instances", obj_projectile);

proj.direction = facing_dir;
proj.speed = 10;
proj.damage = damage;

// 👇 CRITICAL LINE
proj.weapon_data = current_weapon_data;
    }
}

// =====================
// ARMOR BREAKDOWN LOGIC
// =====================

if (hurt_timer > 0) {
    hurt_timer--;
    image_blend = c_red;
} else {
    image_blend = c_white;
}