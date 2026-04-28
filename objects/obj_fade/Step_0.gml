// Fade IN
if (fade > 0 && target_room == -1) {
    fade -= fade_speed;
}

// Fade OUT
if (target_room != -1) {
    fade += fade_speed;

    if (fade >= 1) {
        room_goto(target_room);
        target_room = -1;
    }
}