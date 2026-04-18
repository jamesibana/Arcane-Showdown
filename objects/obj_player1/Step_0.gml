// =====================
// SAFE INIT
// =====================
if (!initialized && is_struct(character_data)) {
    hp = character_data.hp;
    move_speed = character_data.speed;
    initialized = true;
}

// =====================
// SAFE WEAPON INIT (RUNS ONCE)
// =====================
if (current_weapon_data == undefined && global.weapon_data != undefined) {

    current_weapon = "melee"; // default only once
    current_weapon_data = global.weapon_data[$ current_weapon];

    if (current_weapon_data != undefined) {
        weapon_sprite = current_weapon_data.sprite;
        damage = current_weapon_data.damage;
        cooldown = current_weapon_data.cooldown;
        range = current_weapon_data.range;
    }
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
// PICKUP (Q KEY ONLY)
// =====================
if (keyboard_check_pressed(ord("Q"))) {

    var pickup = instance_nearest(x, y, obj_weapon_pickup);

    if (pickup != noone && point_distance(x, y, pickup.x, pickup.y) < 40) {

        // =====================
        // PICKUP / SWAP SYSTEM
        // =====================

        var old_weapon = current_weapon;

        var new_weapon = pickup.weapon_key;
        var new_data = variable_struct_get(global.weapon_data, new_weapon);

        // DROP OLD WEAPON
        var drop = instance_create_layer(x, y, "Instances", obj_weapon_pickup);
        drop.weapon_key = old_weapon;

        if (is_struct(global.weapon_data) && variable_struct_exists(global.weapon_data, old_weapon)) {
            drop.weapon_sprite = variable_struct_get(global.weapon_data, old_weapon).sprite;
        }

        // EQUIP NEW WEAPON
        current_weapon = new_weapon;
        current_weapon_data = new_data;

        weapon_sprite = new_data.sprite;
        damage = new_data.damage;
        cooldown = new_data.cooldown;
        range = new_data.range;

        instance_destroy(pickup);

    } else {

        // =====================
        // NO PICKUP → TOGGLE MODE
        // =====================

        if (active_weapon_type == "melee") {
            active_weapon_type = "ranged";
            current_weapon_data = weapon_ranged_data;
        } else {
            active_weapon_type = "melee";
            current_weapon_data = weapon_melee_data;
        }

        weapon_sprite = current_weapon_data.sprite;
        damage = current_weapon_data.damage;
        cooldown = current_weapon_data.cooldown;
        range = current_weapon_data.range;
    }
}