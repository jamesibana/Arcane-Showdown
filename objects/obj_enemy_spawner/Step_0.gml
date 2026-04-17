spawn_timer--;

if (spawn_timer <= 0) {

    var mid = room_width / 2;

    // LEFT LANE spawn
    var x1 = irandom_range(50, mid - 50);
    var y1 = irandom_range(50, room_height - 50);
    instance_create_layer(x1, y1, "Instances", obj_enemy);

    // RIGHT LANE spawn
    var x2 = irandom_range(mid + 50, room_width - 50);
    var y2 = irandom_range(50, room_height - 50);
    instance_create_layer(x2, y2, "Instances", obj_enemy);

    spawn_timer = room_speed * 2;
}