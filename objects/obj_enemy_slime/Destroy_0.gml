global.enemy_kills += 1;

// chance to drop weapon
if (irandom(100) < 15) { // 15% drop chance

    var drop = instance_create_layer(x, y, "Instances", obj_weapon_pickup);

    var keys = ["sword","dagger","spear","mace","bow","crossbow","blow_dart","poison_spray"];
    var chosen = keys[irandom(array_length(keys) - 1)];

    with (drop) {
        weapon_key = chosen;
        sprite_index = global.weapon_data[chosen].sprite;
    }
}