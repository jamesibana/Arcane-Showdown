if (variable_global_exists("spawner_list")) {

    var len = array_length(global.spawner_list);

    for (var i = 0; i < len; i++) {

        if (global.spawner_list[i] == id) {

            array_delete(global.spawner_list, i, 1);
            break;
        }
    }
}