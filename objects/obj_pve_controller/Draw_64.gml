draw_set_font(fnt_menu);
draw_set_halign(fa_center);

var seconds = ceil(pve_timer / room_speed);

draw_text(room_width/2, 20, "Time: " + string(seconds));