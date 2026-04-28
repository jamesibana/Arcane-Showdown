// =====================
// KILL COUNT
// =====================
global.enemy_kills += 1;

// =====================
// DROP SETTINGS
// =====================
var drop_chance = 55;

// roll
if (irandom(99) < drop_chance) {

    var all_names = variable_struct_get_names(global.weapon_data);
    var valid_drops = []; // 🛑 NEW: An empty array to hold the weapons we actually want

    // 🛑 NEW: Loop through all the weapons and filter out the defaults
    for (var i = 0; i < array_length(all_names); i++) {
        var wp_name = all_names[i];
        
        // If the weapon is NOT a sword, and NOT a bow, add it to our valid drops list!
        if (wp_name != "sword" && wp_name != "bow") {
            array_push(valid_drops, wp_name);
        }
    }

    // Now we roll from our clean valid_drops array instead of the raw one!
    if (array_length(valid_drops) > 0) {

        var drop_key = valid_drops[irandom(array_length(valid_drops) - 1)];
        var data = get_weapon(drop_key);

        if (data != undefined) {

            var drop = instance_create_layer(x, y, "Instances", obj_weapon_pickup);
            drop.weapon_key = drop_key;
            drop.weapon_sprite = data.sprite;
            
        }
    }
}