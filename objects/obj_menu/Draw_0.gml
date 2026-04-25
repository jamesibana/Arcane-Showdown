draw_set_font(fnt_menu);

var cx = room_width / 2;

draw_sprite_ext(game_logo, 0, cx-280, 380, 0.4, 0.4, 0, c_white, 1);
draw_sprite_ext(spr_bg_menu,0,x,y,1,1,0,make_color_rgb(255,220,170),1);
image_alpha = 0.18;
x += random_range(-0.2,0.2);
y += 0.1;
image_alpha = 0.3;