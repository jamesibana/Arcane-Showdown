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

    var hit = instance_place(nx, ny, obj_damageable);

    if (hit != noone) {

        // ❌ ignore shooter
        if (hit.id == owner_id) {
            x = nx;
            y = ny;
            exit;
        }

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

            hurt_timer = 10;
        }
		global.hitpause = 4;
        instance_destroy();
        exit;
    }

    x = nx;
    y = ny;

    image_angle = direction - 45;

    exit;
}


// =====================================================
// 🟣 TRAVEL MODE (POISON PROJECTILE)
// =====================================================
if (mode == "travel") {

    image_speed = 0.2;

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
// 🟣 CLOUD MODE (POISON)
// =====================================================
if (mode == "cloud") {

    cloud_radius = min(cloud_radius + cloud_growth, cloud_max_radius);

    image_xscale = cloud_radius / 20;
    image_yscale = image_xscale;

    image_alpha = lifetime / 60;
    image_speed = 0.3;

    // =========================
    // 🔥 FIXED: MULTI TARGET POISON
    // =========================
    with (obj_damageable) {

        // ignore shooter
        if (id == other.owner_id) continue;

        var dist = point_distance(x, y, other.x, other.y);

        if (dist < other.cloud_radius * 2.5) {

            poison_timer = 60;
            poison_damage = 1;

            hurt_timer = 5;
        }
    }

    lifetime--;

    if (lifetime <= 0) {
        instance_destroy();
    }

    exit;
}