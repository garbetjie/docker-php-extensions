{
    getline cgroups_mem < "/sys/fs/cgroup/memory/memory.limit_in_bytes"
    while ((getline meminfo_mem < "/proc/meminfo") > 0) {
        split(meminfo_mem, meminfo_mem_array);
        if (meminfo_mem_array[1] == "MemTotal:") {
            meminfo_mem = meminfo_mem_array[2] * 1024;
            break;
        }
    }

    if (meminfo_mem > cgroups_mem) {
        available_mem = cgroups_mem / 1024 / 1024;
    } else {
        available_mem = meminfo_mem / 1024 / 1024;
    }

    sub(/[^0-9]+/, "", memory_limit);
    max_children = available_mem * 0.9 / memory_limit;
    sub(/\.[0-9]+$/, "", max_children);

    if (max_children < 1) max_children = 1;
    print max_children
}
