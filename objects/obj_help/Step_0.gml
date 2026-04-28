// ============================
// NAVIGATION
// ============================
if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"))) {
    page++;
}

if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"))) {
    page--;
}

// Wrap pages so it loops infinitely
if (page < 0) page = max_pages - 1;
if (page >= max_pages) page = 0;

// ============================
// EXIT TO MENU
// ============================
// Pressing ESC goes back to menu
if (keyboard_check_pressed(vk_escape)) {
    room_goto(rm_menu); 
}