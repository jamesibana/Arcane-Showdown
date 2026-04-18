var index = array_index_of(global.spawner_list, id);

if (index != -1) {
    array_delete(global.spawner_list, index, 1);
}