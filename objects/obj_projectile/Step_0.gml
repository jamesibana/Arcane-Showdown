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
		
		// ==========================================
        // 🛑 NEW: DISABLE PVP IN CRAWLER ROOM
        // ==========================================
        if (hit.object_index == obj_player1 && room != rm_arena) {
            x = nx;
            y = ny;
            exit; // Ignore the player and let the bullet keep flying!
        }

with (hit) {
            var dmg = other.damage;

            // --- 🐌 NEW: PROJECTILE SLOWDOWN ---
            // If the weapon has a slow multiplier (e.g., 0.5), apply it!
            if (variable_struct_exists(other.weapon_data, "slow_multiplier")) {
                move_speed = character_data.speed * other.weapon_data.slow_multiplier;
                // Note: We don't need a timer here because your Player's Step Event
                // will naturally reset move_speed to normal once the hitstun/hurt state ends!
            }

            if (!variable_instance_exists(id, "armor")) armor = 0;
            if (!variable_instance_exists(id, "hp")) hp = 1;

            if (armor > 0) {
                var absorbed = min(armor, dmg);
                armor -= absorbed;
                dmg -= absorbed;
            }
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
        if (id == other.owner_id) continue;
        if (object_index == obj_player1 && room != rm_arena) continue;

        var dist = point_distance(x, y, other.x, other.y);

 if (dist < other.cloud_radius * 2.5) {

            poison_timer = 60;
            
            // 🐌 NEW: Safely pass the slowdown multiplier to the victim!
            if (variable_struct_exists(other.weapon_data, "slow_multiplier")) {
                poison_slow_mult = other.weapon_data.slow_multiplier;
            } else {
                poison_slow_mult = 1; // Normal speed if weapon has no slow
            }
            
            poison_damage = 1; 
            if (variable_instance_exists(other.id, "weapon_data")) {
                if (variable_struct_exists(other.weapon_data, "poison_damage")) {
                    poison_damage = other.weapon_data.poison_damage;
                }
            }

            hurt_timer = 5;
        }
    }

    lifetime--;

    if (lifetime <= 0) {
        instance_destroy();
    }

    exit;
}