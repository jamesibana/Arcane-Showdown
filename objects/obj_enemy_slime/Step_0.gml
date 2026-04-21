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

if (dist < attack_range) {

    if (attack_cooldown <= 0) {

        with (target) {
            armor -= other.attack_damage;

// safety fallback (prevents crashes)
if (!variable_instance_exists(id, "armor")) armor = 0;
if (!variable_instance_exists(id, "hp")) hp = 1;
            if (armor < 0) armor = 0;

            hurt_timer = 10;
        }

        attack_cooldown = attack_speed;
    }
}
    }

    attack_cooldown--;

    if (dist_to_player > aggro_exit) {
        state = "return";
    }
}

if (state == "return") {

    if (dist_from_home <= 2) {
        state = "alive";
    }
}


// =====================================================
// 🚶 MOVEMENT
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


// =====================================================
// 🧱 COLLISION MOVE
// =====================================================
if (!place_meeting(x + hsp, y, obj_wall_segment)) x += hsp;
if (!place_meeting(x, y + vsp, obj_wall_segment)) y += vsp;


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