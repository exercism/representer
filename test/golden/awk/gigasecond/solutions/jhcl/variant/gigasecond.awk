{"date -u +%s -d"$0" " | getline d
    "date -u +%FT%T -d@"d-10**9" " | getline e
    print e}

