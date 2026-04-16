
// Initialize ONLY when data is available
if (!is_undefined(character_data) && !variable_instance_exists(id, "initialized")) {

    hp = character_data.hp;
    move_speed = character_data.speed;
    luck = character_data.luck;

    initialized = true;

    show_debug_message("Player " + string(owner_player) + " initialized");
}