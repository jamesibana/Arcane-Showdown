



draw_set_font(fnt_menu);
draw_set_color(c_white);

var c = global.characters[index];

var cx = room_width / 2;
var cy = room_height / 2;



if (!is_undefined(c) && variable_struct_exists(c, "sprite")) {
    var scale = 2 + sin(current_time / 200) * 0.1;

    draw_sprite_ext(
        c.sprite,
        0,
        cx,
        cy,
        scale,
        scale,
        0,
        c_white,
        1
    );
}
 

draw_set_color(c_yellow);
draw_rectangle(cx - 150, cy - 100, cx + 150, cy + 100, false);

//SELECTION
if (global.current_player == 1) {
    draw_text(cx, 120, "→ Player 1 selecting");
} else {
    draw_text(cx, 120, "→ Player 2 selecting");
}

// TITLE
draw_set_halign(fa_center);
draw_set_color(c_white);
draw_text(cx, 80, "SELECT YOUR CHARACTER");


// NAME
draw_set_font(-1);
draw_text(cx, cy - 60, c.name);



// STATS
draw_text(cx, cy - 20, "HP: " + string(c.hp));
draw_text(cx, cy + 10, "Speed: " + string(c.speed));
draw_text(cx, cy + 40, "Luck: " + string(c.luck));

// DESCRIPTION 
if (variable_struct_exists(c, "desc")) {
    draw_text(cx, cy + 80, c.desc);
}

// NAV HELP
draw_text(cx, room_height - 80, "< LEFT / RIGHT >  |  ENTER TO SELECT");

//LOCK DRAW
var player_wins = 0;

if (global.current_player == 1) {
    player_wins = global.p1_wins;
} else {
    player_wins = global.p2_wins;
}

if (c.unlock_wins > player_wins) {
    draw_set_color(c_red);
    draw_text(cx, cy + 120, "LOCKED");
    draw_text(cx, cy + 140, "Requires " + string(c.unlock_wins) + " wins");
}