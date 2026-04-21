
// draw player
draw_self();

// draw weapon
draw_sprite(weapon_sprite, 0, x, y);

// ============================
// PLAYER INDICATOR (SPRITE VERSION)
// ============================

var ind_y = y - sprite_get_bbox_top(sprite_index) - 50;
var ind_x = x;

var spr = (owner_player == 1)
    ? spr_indicator_1
    : spr_indicator_2;

draw_sprite(spr, 0, ind_x, ind_y);

// =====================
// PLAYER BARS
// =====================

// bar settings
var bar_w = 40;
var bar_h = 4;

// position above player
var bx = x - bar_w / 2;
var by = y - 30;

// =====================
// ARMOR BAR (TOP)
// =====================
draw_set_color(c_gray);
draw_rectangle(bx, by, bx + bar_w, by + bar_h, false);

draw_set_color(c_aqua);
draw_rectangle(bx, by, bx + (bar_w * (armor / max_armor)), by + bar_h, false);

// =====================
// HP BAR (BOTTOM)
// =====================
draw_set_color(c_black);
draw_rectangle(bx, by + 6, bx + bar_w, by + 6 + bar_h, false);

draw_set_color(c_lime);
draw_rectangle(bx, by + 6, bx + (bar_w * (hp / max_hp)), by + 6 + bar_h, false);

draw_set_color(c_white);