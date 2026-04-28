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

            // ==========================================
            // 🏹 REVERSE DAMAGE FALLOFF (DISTANCE SCALING)
            // ==========================================
            if (variable_struct_exists(other.weapon_data, "distance_scaling") && other.weapon_data.distance_scaling == true) {
                
                var safe_max_range = variable_instance_exists(other.id, "max_range") ? other.max_range : 400;
                var dist = point_distance(other.xstart, other.ystart, other.x, other.y);
                var travel_pct = clamp(dist / safe_max_range, 0, 1);
                var multiplier = lerp(0.67, 1.0, travel_pct);
                
                dmg = dmg * multiplier;
            }

            // ==========================================
            // --- 🐌 PROJECTILE SLOWDOWN ---
            // ==========================================
            if (variable_struct_exists(other.weapon_data, "slow_multiplier")) {
                move_speed = character_data.speed * other.weapon_data.slow_multiplier;
            }

            if (!variable_instance_exists(id, "armor")) armor = 0;
            if (!variable_instance_exists(id, "hp")) hp = 1;

            // 🛑 THE FIX: Save the damage BEFORE armor eats it!
            var dmg_to_show = dmg; 

            // Resolve Armor
            if (armor > 0) {
                var absorbed = min(armor, dmg);
                armor -= absorbed;
                dmg -= absorbed;
            }
            
            // Resolve HP
            if (dmg > 0) hp -= dmg;

            // 🛑 NEW: SPAWN THE FLOATING TEXT!
            if (dmg_to_show > 0) {
                
                var spawn_height = 40; 
                if (object_index == obj_player1) spawn_height = 180; // Taller for players!
                
                var float_x = x + random_range(-15, 15);
                var float_y = y - spawn_height;
                
                var float_text = instance_create_layer(float_x, float_y, "Instances", obj_damage_indicator);
                
                // 🎯 round() ensures it prints "7" instead of "6.73" from the distance scaling math!
                float_text.damage = round(dmg_to_show); 
                float_text.color = c_white; 
            }

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