if (room == rm_arena) {

    // reset visual state (important after PvE)
    image_blend = c_white;
    image_alpha = 1;
    image_angle = 0;

    // OPTIONAL: reset temporary combat states
    attack_cooldown = 0;

    // position players
    if (owner_player == 1) {
        x = 200;
        y = 545;
    }

    if (owner_player == 2) {
        x = room_width - 200;
        y = 545;
    }
}