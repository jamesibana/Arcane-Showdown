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
    draw_sprite_ext(spr_char_select_ui_top, 0, room_width / 2, 90,
        room_width / sprite_get_width(spr_char_select_ui_top), 1, 0, c_white, 1);
}

if (sprite_exists(spr_char_select_ui_side)) {
    draw_sprite_ext(spr_char_select_ui_side, 0, room_width * 0.75, room_height / 2,
        1, room_height / sprite_get_height(spr_char_select_ui_side), 0, c_white, 1);
}

if (sprite_exists(spr_char_select_ui_bottom)) {
    draw_sprite_ext(spr_char_select_ui_bottom, 0, room_width / 2, room_height - 70,
        room_width / sprite_get_width(spr_char_select_ui_bottom), 1, 0, c_white, 1);
}

draw_set_alpha(1);


// ============================
// TOP TEXT
// ============================
var top_y = 90;

draw_set_halign(fa_center);
draw_set_color(c_white);

// 1. Main Title
draw_text(room_width / 2, top_y, "SELECT YOUR CHARACTER");

// 2. Player Turn
draw_text(room_width / 2, top_y + 30,
    (global.current_player == 1) ? "PLAYER 1 TURN" : "PLAYER 2 TURN"
);

// 3. Player Wins (NEW)
// Draws in a yellow/gold color so it stands out, then resets to white
draw_set_color(c_yellow);
draw_text(room_width / 2, top_y + 60, "LEVEL: " + string(wins));
draw_set_color(c_white);


// ============================
// CHARACTER ANCHOR (BASE POSITION)
// ============================
var cx = room_width * 0.3;
var cy = room_height / 2;


// ============================
// HIGHLIGHT BOX
// ============================
var glow = 0.3 + sin(current_time / 150) * 0.15;

draw_set_color(c_yellow);
draw_set_alpha(glow);

draw_rectangle(cx - 170, cy - 170, cx + 170, cy + 170, false);

draw_set_alpha(1);


// ============================
// SPRITE PREVIEW
// ============================
var scale = 4 + sin(current_time / 200) * 0.1;

var sw = sprite_get_width(c.sprite) * scale;
var sh = sprite_get_height(c.sprite) * scale;


// =====================================================
// SPRITE OFFSET (ONLY MOVES CHARACTER VISUAL)
// =====================================================
var sprite_offset_x = 116;
var sprite_offset_y = 140;


// FINAL SPRITE POSITION
var draw_x = cx - (sw / 2) + sprite_offset_x;
var draw_y = cy - (sh / 2) + sprite_offset_y;


// ============================
// DRAW CHARACTER
// ============================
if (locked) {

    draw_set_alpha(0.15);

    draw_sprite_ext(c.sprite, 0, draw_x, draw_y,
        scale + 0.1, scale + 0.1, 0, c_black, 1);

    draw_set_alpha(1);

    draw_set_color(c_red);
    draw_set_halign(fa_center);
    draw_text(cx, cy, "LOCKED");
    draw_set_halign(fa_left);

    draw_set_color(c_white);

} else {

    draw_sprite_ext(c.sprite, 0, draw_x, draw_y,
        scale, scale, 0, c_white, 1);
}


// ============================
// CHARACTER SELECT INDICATOR (FIXED)
// ============================


// ============================
// CHARACTER SELECT INDICATOR
// ============================

// 1. SAFETY CHECK (avoid crashes if sprites missing)
if (sprite_exists(spr_indicator_1) && sprite_exists(spr_indicator_2)) {

    // ============================
    // 2. SELECT INDICATOR TYPE
    // ============================
    var indicator_spr = (global.current_player == 1)
        ? spr_indicator_1
        : spr_indicator_2;

    // ============================
    // 3. BASE ANCHOR (FOLLOW CHARACTER PREVIEW)
    // ============================
    var cx = room_width * 0.3;
    var cy = room_height / 2;

    // IMPORTANT: match this to your sprite preview system
    var scale = 4 + sin(current_time / 200) * 0.1;

    var sw = sprite_get_width(c.sprite) * scale;
    var sh = sprite_get_height(c.sprite) * scale;

    // This MUST match your character draw offset system
    var sprite_offset_x = 116;
    var sprite_offset_y = 140;

    var draw_x = cx - (sw / 2) + sprite_offset_x;
    var draw_y = cy - (sh / 2) + sprite_offset_y;

    // ============================
    // 4. INDICATOR POSITION CONTROL
    // ============================

    var ind_offset_x = -118;     // ← left/right adjust
    var ind_offset_y = -170;   // ← up/down adjust (negative = above head)

    var ind_x = draw_x + (sw / 2) + ind_offset_x;
    var ind_y = draw_y + ind_offset_y;

    // ============================
    // 5. DRAW INDICATOR
    // ============================
	var ind_scale = 3;
	
    draw_sprite_ext(
        indicator_spr,
        0,
        ind_x,
        ind_y,
        ind_scale,
        ind_scale,
        0,
        c_white,
        1
    );
}


// ============================
// RIGHT PANEL (INFO BOX)
// ============================
if (!variable_instance_exists(id, "box_w")) box_w = 300;
if (!variable_instance_exists(id, "padding")) padding = 10;

var ix = room_width * 0.72;
var iy = room_height * 0.30;

draw_set_font(fnt_menu);
draw_set_halign(fa_left);

var line_h = 50;
var desc_line_space = line_h + 6;

if (is_undefined(c)) exit;


// BOX HEIGHT CALC
var total_h = line_h * 4 + 8;

if (variable_struct_exists(c, "desc")) {
    total_h += string_height_ext(c.desc, desc_line_space, box_w - padding * 2);
}

if (locked) total_h += line_h * 2;

var box_h = total_h + padding * 2;


// BOX
draw_set_alpha(0.4);
draw_set_color(c_white);

draw_rectangle(ix - 20, iy - 20, ix - 20 + box_w, iy - 20 + box_h, false);

draw_set_alpha(1);


// TEXT
draw_set_color(c_black);

var line = padding;

draw_text(ix + padding, iy + line, c.name);
line += line_h * 1.2;

draw_text(ix + padding, iy + line, "Armor: " + string(c.armor));
line += line_h;

draw_text(ix + padding, iy + line, "Speed: " + string(c.speed));
line += line_h;

draw_text(ix + padding, iy + line, "Luck: " + string(c.luck));
line += line_h;


// DESCRIPTION
if (variable_struct_exists(c, "desc")) {

    draw_text_ext(ix + padding, iy + line,
        c.desc, desc_line_space,
        box_w - padding * 2);

    line += string_height_ext(c.desc, desc_line_space, box_w - padding * 2);
}

line += 10;


// LOCK INFO
if (locked) {

    draw_set_color(c_red);

    draw_text(ix + padding, iy + line, "LOCKED");
    line += line_h;

    draw_text(ix + padding, iy + line,
        "Requires level " + string(c.unlock_wins));

    draw_set_color(c_black);
}


// ============================
// BOTTOM HELP TEXT
// ============================
var bottom_y = room_height - 70;

draw_set_halign(fa_center);
draw_set_color(c_white);

draw_text(room_width / 2, bottom_y,
    (global.current_player == 1)
    ? "A / D to move | ENTER to select"
    : "LEFT / RIGHT to move | ENTER to select"
);


// ============================
// INPUT
// ============================
if (global.game_state == "character_select") {

    if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A")))
        character_index -= 1;

    if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D")))
        character_index += 1;

    if (character_index < 0) character_index = max_char - 1;
    if (character_index >= max_char) character_index = 0;
}