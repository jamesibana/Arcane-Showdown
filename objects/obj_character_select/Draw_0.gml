var c = global.characters[index];

var wins = (global.current_player == 1)
    ? global.p1_wins
    : global.p2_wins;

var locked = (c.unlock_wins > wins);

// ============================
// BACKGROUND
// ============================
draw_sprite_ext(
    spr_bg_select,
    0,
    room_width / 2,
    room_height / 2,
    room_width / sprite_get_width(spr_bg_select),
    room_height / sprite_get_height(spr_bg_select),
    0,
    c_white,
    1
);


// ============================
// SETUP
// ============================
draw_set_font(fnt_menu);
draw_set_color(c_white);
draw_set_halign(fa_left);


// ============================
// CURRENT CHARACTER
// ============================

var cx = room_width * 0.3;
var cy = room_height / 2;


// ============================
// SPRITE PREVIEW
// ============================
var scale = 4 + sin(current_time / 200) * 0.1;

if (locked) {
    draw_set_alpha(0.15);
    draw_sprite_ext(c.sprite, 0, cx - 140, cy - 70, scale+0.1, scale+0.1, 0, c_black, 1);
    draw_set_alpha(1);
}
else {
    draw_sprite_ext(
        c.sprite,
        0,
        cx-140,
        cy-70,
        scale,
        scale,
        0,
        c_white,
        1
    );
}

// ============================
// NAV HELP (ADAPTIVE)
// ============================
draw_set_halign(fa_center);
draw_set_color(c_white);

if (global.current_player == 1) {
    draw_text(
        room_width / 2,
        room_height - 80,
        "Player 1: A / D to move | ENTER to select"
    );
}
else {
    draw_text(
        room_width / 2,
        room_height - 80,
        "Player 2: LEFT / RIGHT to move | ENTER to select"
    );
}


// ============================
// TITLE + TURN INDICATOR
// ============================
draw_set_halign(fa_center);
draw_text(room_width / 2, 80, "SELECT YOUR CHARACTER");

if (global.current_player == 1) {
    draw_text(room_width / 2, 120, "Player 1 selecting");
} else {
    draw_text(room_width / 2, 120, "Player 2 selecting");
}


// ============================
// RIGHT INFO PANEL
// ============================
var ix = room_width * 0.65;
var iy = room_height * 0.35;

draw_set_halign(fa_left);

// NAME
draw_text(ix, iy, c.name);

// STATS
draw_text(ix, iy + 40, "Armor: " + string(c.armor));
draw_text(ix, iy + 70, "Speed: " + string(c.speed));
draw_text(ix, iy + 100, "Luck: " + string(c.luck));

// DESCRIPTION
if (variable_struct_exists(c, "desc")) {
    draw_text(ix, iy + 150, c.desc);
}


// ============================
// LOCK CHECK (CURRENT CHARACTER ONLY)
// ============================
var wins = (global.current_player == 1)
    ? global.p1_wins
    : global.p2_wins;

if (c.unlock_wins > wins) {
    draw_set_color(c_red);
    draw_text(ix, iy + 200, "LOCKED");
    draw_text(ix, iy + 220, "Requires " + string(c.unlock_wins) + " wins");
}