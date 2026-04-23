var scale = base_scale + abs(sin(pulse_time)) * pulse_amount;

//GLOW (draw behind)

draw_sprite_ext(sprite_index, 0, x, y,
	scale + 0.06, scale + 0.06, 0, c_yellow, glow_alpha);
	
//MAIN LOGO
draw_sprite_ext(sprite_index, 0, x, y,
	scale, scale, 0, c_white, 1);