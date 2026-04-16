// countdown
pve_timer--;

// when time ends → go to PvP
if (pve_timer <= 0) {
    room_goto(rm_pvp);
}