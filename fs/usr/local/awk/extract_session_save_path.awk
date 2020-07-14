{
    if ($1 == "session.save_handler") {
        if ($3 == "files") next; else exit;
    }

    sub(/^"/, "", $3);
    sub(/"$/, "", $3);
    print $3
}
