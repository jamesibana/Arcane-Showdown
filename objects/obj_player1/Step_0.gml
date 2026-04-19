if (attack_cooldown > 0) {
    attack_cooldown--;
}

// =====================
// SAFE INIT
// =====================
if (!initialized && is_struct(character_data)) {
    hp = character_data.hp;
    move_speed = character_data.speed;
    initialized = true;
}

var attack_pressed = false;

if (owner_player == 1 && keyboard_check_pressed(ord("W")) ||  keyboard_check_pressed(ord("A")) 
||  keyboard_check_pressed(ord("S")) ||  keyboard_check_pressed(ord("D"))) {
    attack_pressed = true;
}

if (owner_player == 2 && keyboard_check_pressed(ord("M"))) {
    attack_pressed = true;
}


// =====================
// INPUT
// =====================
var h = 0;
var v = 0;

if (owner_player == 1) {
    h = keyboard_check(ord("D")) - keyboard_check(ord("A"));
    v = keyboard_check(ord("S")) - keyboard_check(ord("W"));
} else {
    h = keyboard_check(vk_right) - keyboard_check(vk_left);
    v = keyboard_check(vk_down) - keyboard_check(vk_up);
}

// =====================
// MOVEMENT + COLLISION
// =====================
var new_x = x + h * move_speed;
var new_y = y + v * move_speed;

if (!place_meeting(new_x, y, obj_wall_segment)) x = new_x;
if (!place_meeting(x, new_y, obj_wall_segment)) y = new_y;

// =====================
// SWAP COOLDOWN
// =====================
if (swap_cooldown > 0) swap_cooldown--;

// =====================
// INTERACT KEY
// =====================
var pressed = false;

if (swap_cooldown <= 0) {

    if (owner_player == 1 && keyboard_check_pressed(ord("Q"))) {
        pressed = true;
    }

    if (owner_player == 2 && keyboard_check_pressed(vk_control)) {
        pressed = true;
    }
}

// =====================
// PICKUP / TOGGLE
// =====================
if (pressed) {

    var pickup = instance_nearest(x, y, obj_weapon_pickup);
    var has_pickup = (pickup != noone && point_distance(x, y, pickup.x, pickup.y) < 40);

    if (has_pickup) {

        var new_key = pickup.weapon_key;
        var new_data = get_weapon(new_key);

        if (new_data != undefined) {

            // DETERMINE TYPE
            var new_type = new_data.type;

            // DROP CORRECT SLOT
            var drop_key;

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

            // REPLACE SLOT
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
        // TOGGLE ONLY IF NO PICKUP
        active_weapon_type = (active_weapon_type == "melee") ? "ranged" : "melee";
    }

    // APPLY COOLDOWN (prevents spam swapping)
    swap_cooldown = 10;
}

// =====================
// RESOLVE ACTIVE WEAPON
// =====================
var resolved = (active_weapon_type == "melee") ? weapon_melee_data : weapon_ranged_data;

// fallback safety
if (resolved == undefined) {
    resolved = get_weapon("sword");
    weapon_melee_data = resolved;
    active_weapon_type = "melee";
}

// APPLY STATS
current_weapon_data = resolved;

weapon_sprite = resolved.sprite;
damage = resolved.damage;
cooldown = resolved.cooldown;
range = resolved.range;

if (attack_pressed && attack_cooldown <= 0) {

    attack_cooldown = cooldown;

    if (active_weapon_type == "melee") {

        // MELEE HITBOX
        var hit = instance_place(x + lengthdir_x(range, image_angle),
                                  y + lengthdir_y(range, image_angle),
                                  obj_enemy_minion);

        if (hit != noone) {
            with (hit) {
                hp -= other.damage;
            }
        }

    } else {

        // RANGED PROJECTILE
        var proj = instance_create_layer(x, y, "Instances", obj_projectile);

        proj.direction = image_angle;
        proj.speed = 10;
        proj.damage = damage;
        proj.owner = id;
    }
}