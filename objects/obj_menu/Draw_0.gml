draw_set_font(fnt_menu);

// Fit background exactly to screen
var sx = room_width / sprite_get_width(spr_bg_menu);
var sy = room_height / sprite_get_height(spr_bg_menu);

// Logo
var cx = room_width / 2;
draw_sprite_ext(game_logo, 0, cx - 280, 380, 0.4, 0.4, 0, c_white, 1);