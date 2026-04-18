// draw player sprite
draw_self();

// weapon text
draw_set_font(fnt_menu);
draw_set_halign(fa_center);

var text;

if (current_weapon == "melee") {
    text = "Melee: " + melee_weapon;
} else {
    text = "Ranged: " + ranged_weapon;
}

draw_text(x, y - 40, text);