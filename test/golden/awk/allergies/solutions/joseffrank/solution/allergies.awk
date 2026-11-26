BEGIN {
    PROCINFO["sorted_in"]="@val_num_asc"
    FS=","
    all["eggs"] = 1
    all["peanuts"] = 2
    all["shellfish"] = 4
    all["strawberries"] = 8
    all["tomatoes"] = 16
    all["chocolate"] = 32
    all["pollen"] = 64
    all["cats"] = 128
    a = "false"
    getline
    if (NF==3 && and($1,all[$3])) a="true"
    if (NF==2 && $2=="list") {
        if ($1==0) exit
        a = ""
        for (i in all) {
            if (and($1,all[i])) a = a "," i
        }
        sub("^,","",a)
    }
    print a
}
