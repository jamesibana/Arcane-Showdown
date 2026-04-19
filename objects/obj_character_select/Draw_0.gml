draw_self();

// ============================
// DATA
// ============================
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
// UI PANELS (BREATHING)
// ============================
var ui_pulse = 0.5 + sin(current_time / 250) * 0.2;

draw_set_alpha(ui_pulse);
draw_set_color(c_white);

if (sprite_exists(spr_char_select_ui_top)) {
    draw_sprite_ext(
       spr_char_select_ui_top,
       0,
       room_width / 2,
       90,
       room_width / sprite_get_width(spr_char_select_ui_top),
       1,
       0,
       c_white,
       1
    );
}

if (sprite_exists(spr_char_select_ui_side)) {
    draw_sprite_ext(
       spr_char_select_ui_side,
       0,
       room_width * 0.75,
       room_height / 2,
       1,
       room_height / sprite_get_height(spr_char_select_ui_side),
       0,
       c_white,
       1
    );
}

if (sprite_exists(spr_char_select_ui_bottom)) {
    draw_sprite_ext(
       spr_char_select_ui_bottom,
       0,
       room_width / 2,
       room_height - 70,
       room_width / sprite_get_width(spr_char_select_ui_bottom),
       1,
       0,
       c_white,
       1
    );
}

draw_set_alpha(1);

// ============================
// 🟡 TOP PANEL TEXT
// ============================
var top_y = 90;

draw_set_halign(fa_center);
draw_set_color(c_white);

draw_text(room_width / 2, top_y, "SELECT YOUR CHARACTER");

if (global.current_player == 1) {
    draw_text(room_width / 2, top_y + 30, "PLAYER 1 TURN");
} else {
    draw_text(room_width / 2, top_y + 30, "PLAYER 2 TURN");
}

// ============================
// CHARACTER POSITION
// ============================
var cx = room_width * 0.3;
var cy = room_height / 2;

// ============================
// HIGHLIGHT BOX
// ============================
var glow = 0.3 + sin(current_time / 150) * 0.15;

draw_set_color(c_yellow);
draw_set_alpha(glow);

draw_rectangle(
    cx - 170,
    cy - 170,
    cx + 170,
    cy + 170,
    false
);

draw_set_alpha(1);

// ============================
// SPRITE PREVIEW
// ============================
var scale = 4 + sin(current_time / 200) * 0.1;

// ⭐ CENTERING FIX
var sw = sprite_get_width(c.sprite) * scale;
var sh = sprite_get_height(c.sprite) * scale;

var draw_x = cx - (sw / 2);
var draw_y = cy - (sh / 2);

if (locked) {
    draw_set_alpha(0.15);

    draw_sprite_ext(
        c.sprite,
        0,
        draw_x,
        draw_y,
        scale + 0.1,
        scale + 0.1,
        0,
        c_black,
        1
    );

    draw_set_alpha(1);

    draw_set_color(c_red);
    draw_set_halign(fa_center); // ⭐ center text
    draw_text(cx, cy, "LOCKED");
    draw_set_halign(fa_left);   // reset

    draw_set_color(c_white);
}
else {
    draw_sprite_ext(
        c.sprite,
        0,
        draw_x,
        draw_y,
        scale,
        scale,
        0,
        c_white,
        1
    );
}


// ============================
// 🟡 RIGHT PANEL (CLEAN FIXED)
// ============================

// ============================
// SAFE DEFAULTS
// ============================
if (!variable_instance_exists(id, "box_w")) box_w = 300;
if (!variable_instance_exists(id, "padding")) padding = 10;

var ix = room_width * 0.72;
var iy = room_height * 0.30;

// ============================
// FONT SETUP
// ============================
draw_set_font(fnt_menu);
draw_set_halign(fa_left);

var line_h = 50;
var desc_line_space = line_h + 6; // ⭐ spacing fix
var total_h = 0;

// safety
if (is_undefined(c)) exit;

// ============================
// COMPUTE HEIGHT FIRST
// ============================
total_h += line_h * 1.2; // name
total_h += line_h * 3;   // stats
total_h += 8;            // gap

// description height (FIXED)
if (variable_struct_exists(c, "desc")) {
    var desc_h = string_height_ext(c.desc, desc_line_space, box_w - (padding * 2));
    total_h += desc_h;
}

total_h += 10;

// lock text
if (locked) {
    total_h += line_h * 2;
}

// FINAL BOX HEIGHT
var box_h = total_h + (padding * 2);

// ============================
// DRAW BOX
// ============================
draw_set_alpha(0.4);
draw_set_color(c_white);

draw_rectangle(
    ix - 20,
    iy - 20,
    ix - 20 + box_w,
    iy - 20 + box_h,
    false
);

draw_set_alpha(1);

// ============================
// DRAW TEXT
// ============================
draw_set_color(c_black);

var line = padding;

// NAME
draw_text(ix + padding, iy + line, c.name);
line += line_h * 1.2;

// STATS
draw_text(ix + padding, iy + line, "Armor: " + string(c.armor));
line += line_h;

draw_text(ix + padding, iy + line, "Speed: " + string(c.speed));
line += line_h;

draw_text(ix + padding, iy + line, "Luck: " + string(c.luck));
line += line_h;

line += 8;

// ============================
// DESCRIPTION (FIXED SPACING)
// ============================
if (variable_struct_exists(c, "desc")) {

    draw_text_ext(
        ix + padding,
        iy + line,
        c.desc,
        desc_line_space,
        box_w - (padding * 2)
    );

    line += string_height_ext(c.desc, desc_line_space, box_w - (padding * 2));
}

line += 10;

// ============================
// LOCK INFO
// ============================
if (locked) {
    draw_set_color(c_red);

    draw_text(ix + padding, iy + line, "LOCKED");
    line += line_h;

    draw_text(ix + padding, iy + line, "Requires " + string(c.unlock_wins) + " wins");

    draw_set_color(c_black);
}



// ============================
// 🟡 BOTTOM PANEL (NAV HELP)
// ============================
var bottom_y = room_height - 70;

draw_set_halign(fa_center);
draw_set_color(c_white);

if (global.current_player == 1) {
    draw_text(room_width / 2, bottom_y,
        "A / D to move | ENTER to select"
    );
} else {
    draw_text(room_width / 2, bottom_y,
        "LEFT / RIGHT to move | ENTER to select"
    );
}

if (global.game_state == "character_select") {

    // LEFT / A = previous character
    if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"))) {
        character_index -= 1;
    }

    // RIGHT / D = next character
    if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"))) {
        character_index += 1;
    }

    // loop (optional)
    if (character_index < 0) character_index = max_char - 1;
    if (character_index >= max_char) character_index = 0;
}

draw_text(100, 100, "Character: " + string(character_index));