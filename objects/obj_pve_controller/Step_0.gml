pve_timer--;


//move to pvp arena when timer runs out
if (pve_timer <= 0) {
    room_goto(rm_pvp);
}