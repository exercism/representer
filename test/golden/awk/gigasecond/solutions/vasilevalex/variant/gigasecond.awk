BEGIN {
    FS="[-T:]"
}
{
    str_date=""
    for(i=1;i<=6;i++){
        str_date=sprintf("%s%s", str_date, ($i!="" ? "00 " : $i" "))
    }
    print(strftime("%FT%H:%M:%S", (mktime(str_date) + 1000000000), utc-flag))
}
