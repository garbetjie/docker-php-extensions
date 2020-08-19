{
    getline cgroups_mem < "/sys/fs/cgroup/memory/memory.limit_in_bytes"
    while ((getline meminfo_mem < "/proc/meminfo") > 0) {
        split(meminfo_mem, meminfo_mem_array);
        if (meminfo_mem_array[1] == "MemTotal:") {
            meminfo_mem = meminfo_mem_array[2] * 1024;
            break;
        }
    }

    # The "/1024/1024" converts bytes into megabytes.
    if (meminfo_mem > cgroups_mem) {
        available_mem = cgroups_mem / 1024 / 1024;
    } else {
        available_mem = meminfo_mem / 1024 / 1024;
    }

    if (match(memory_limit, /[G|M]$/) > 0) {
        suffix = substr(memory_limit, RSTART, RLENGTH);
    } else {
        suffix = "M";
    }

    if (suffix == "G") {
        multiplier = 1024;
    } else {
        multiplier = 1;
    }

    if (match(memory_limit, /^[0-9]+/) > 0) {
        memory_limit = substr(memory_limit, RSTART, RLENGTH) * multiplier;
    } else {
        memory_limit = 64;
    }

    max_children = available_mem * 0.9 / memory_limit;
    sub(/\.[0-9]+$/, "", max_children);

    if (max_children < 1) max_children = 1;
    print max_children
}
