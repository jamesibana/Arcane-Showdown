
pve_timer--;

// when time runs out
if (pve_timer <= 0) {

    room_goto(rm_arena);
}