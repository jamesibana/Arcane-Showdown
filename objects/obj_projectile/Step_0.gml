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

    cloud_radius = 0;
    cloud_growth = 1.5;
    cloud_max_radius = 60;

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

    var hit = instance_place(nx, ny, obj_enemy_parent);

    if (hit != noone) {

        hit.hp -= damage;
        hit.hurt_timer = 10;

        instance_destroy();
        exit;
    }

    x = nx;
    y = ny;

    image_angle = direction - 45;

    exit;
}


// =====================================================
// 🟣 TRAVEL MODE
// =====================================================
if (mode == "travel") {

    image_speed = 0.2;

    cloud_radius += 0.5;

    image_xscale = cloud_radius / 20;
    image_yscale = image_xscale;

    var nx = x + lengthdir_x(speed, direction);
    var ny = y + lengthdir_y(speed, direction);

    if (place_meeting(nx, ny, obj_wall_segment) || distance_traveled >= max_range) {

        mode = "cloud";
        speed = 0;

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


// =====================================================
// 🟣 CLOUD MODE
// =====================================================
if (mode == "cloud") {

    // init safety
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

    image_xscale = cloud_radius / 20;
    image_yscale = image_xscale;

    image_alpha = lifetime / 60;

    image_speed = 0.3;

    // =====================
    // POISON HIT CHECK (FIXED)
    // =====================
    var enemy = instance_place(x, y, obj_enemy_parent);

    if (enemy != noone) {

        var hit_radius = cloud_radius * 2.5;

        if (point_distance(x, y, enemy.x, enemy.y) < hit_radius) {
            enemy.poison_timer = 60;
        }
    }

    lifetime--;

    if (lifetime <= 0) {
        instance_destroy();
    }

    exit;
}