// draw player sprite
draw_self();

// weapon text
draw_set_font(fnt_menu);
draw_set_halign(fa_center);

var text;

var wx = x;
var wy = y;

draw_sprite(weapon_sprite, 0, wx + 32, wy - 8);


if (current_weapon == "melee") {
    weapon_sprite = spr_sword;
}

if (current_weapon == "ranged") {
    weapon_sprite = spr_bow;
}
