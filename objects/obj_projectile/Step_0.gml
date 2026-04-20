show_debug_message("mode: " + string(mode));

// =====================================================
// INIT (SAFE ONCE)
// =====================================================
if (!initialized) {

    if (variable_instance_exists(id, "weapon_data")) {

        if (variable_struct_exists(weapon_data, "projectile_sprite")) {
            sprite_index = weapon_data.projectile_sprite;
        }

        if (variable_struct_exists(weapon_data, "proj_speed")) {
            speed = weapon_data.proj_speed;
        }

        if (variable_struct_exists(weapon_data, "range")) {
            max_range = weapon_data.range;
        }
    }

    // OPTIONAL SAFETY INIT FOR POISON CLOUD
    cloud_radius = 0;
    cloud_growth = 1.5;
    cloud_max_radius = 60;

cloud_init = false;

    initialized = true;
}


// =====================================================
// TYPE CHECK
// =====================================================
var is_poison = false;

if (variable_instance_exists(id, "weapon_data")) {
    if (variable_struct_exists(weapon_data, "cloud_lifetime")) {
        is_poison = true;
    }
}


// =====================================================
// 🟢 NORMAL PROJECTILE
// =====================================================
if (!is_poison) {

    var nx = x + lengthdir_x(speed, direction);
    var ny = y + lengthdir_y(speed, direction);

    if (place_meeting(nx, ny, obj_wall_segment)) {
        instance_destroy();
        exit;
    }

    var hit = instance_place(nx, ny, obj_enemy_minion);
    if (hit != noone) {
        with (hit) hp -= other.damage;
        instance_destroy();
        exit;
    }

    x = nx;
    y = ny;

    image_angle = direction - 45;

    exit;
}


// =====================================================
// 🟣 POISON PROJECTILE STATE MACHINE
// =====================================================


// ---------- TRAVEL ----------
if (mode == "travel") {

    image_speed = 0.2;

    var nx = x + lengthdir_x(speed, direction);
    var ny = y + lengthdir_y(speed, direction);

    if (place_meeting(nx, ny, obj_wall_segment) || distance_traveled >= max_range) {

        mode = "cloud";
        speed = 0;

        // INIT CLOUD (IMPORTANT FIX)
        cloud_radius = 5;
        cloud_growth = 1.5;
        cloud_max_radius = 60;

        lifetime = variable_struct_exists(weapon_data, "cloud_lifetime")
            ? weapon_data.cloud_lifetime
            : 60;

        image_index = 0;
        image_speed = 0.3;

        exit;
    }

    x = nx;
    y = ny;

    distance_traveled += speed;

    image_angle = direction;

    exit;
}


// =====================
// CLOUD STATE
// =====================
if (mode == "cloud") {

    // init once
    if (cloud_radius == 0) {
        cloud_radius = 10;
        cloud_growth = 1.5;
        cloud_max_radius = 60;

        lifetime = variable_struct_exists(weapon_data, "cloud_lifetime")
            ? weapon_data.cloud_lifetime
            : 60;

        image_index = 0;
        image_speed = 0.3;
    }

    // grow cloud
    cloud_radius = min(cloud_radius + cloud_growth, cloud_max_radius);

    // visual scaling
    image_xscale = cloud_radius / 20;
    image_yscale = image_xscale;

    image_speed = 0.3;

    image_alpha = lifetime / 60;

    // debug
    draw_text(x, y - 20, string(cloud_radius));

    // =====================
    // POISON EFFECT
    // =====================
    with (obj_enemy_minion) {

        var poison_time = 60;

        if (other.weapon_data != undefined &&
            variable_struct_exists(other.weapon_data, "poison_duration")) {
            poison_time = other.weapon_data.poison_duration;
        }

        if (point_distance(x, y, other.x, other.y) < other.cloud_radius) {
            poison_timer = poison_time;
        }
    }

    // lifetime
    lifetime--;

    if (lifetime <= 0) {
        instance_destroy();
    }

    exit; // IMPORTANT: stop here
}

    // =====================================================
    // POISON EFFECT
    // =====================================================
    with (obj_enemy_minion) {

        var poison_time = 60;

        if (other.weapon_data != undefined &&
            variable_struct_exists(other.weapon_data, "poison_duration")) {
            poison_time = other.weapon_data.poison_duration;
        }

        if (point_distance(x, y, other.x, other.y) < other.cloud_radius) {
            poison_timer = poison_time;
        }
    }

    // =====================================================
    // DESTROY
    // =====================================================
    if (lifetime <= 0) {
        instance_destroy();
    }