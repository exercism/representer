BEGIN {
    if (type == "decode")
        FPAT = "[[:digit:]]+|[A-Za-z ]"
    else if (type == "encode")
        FS = ""
}
{
    if (type == "decode"){
        for (i = 1; i <= NF; ++i){
            if ($i ~ /[[:digit:]]/){
                iter = $i
                for (j = 1; j <= iter; ++j)
                    res = res""$(i + 1)
                ++i
            }
            else
                res = res""$i
        }
    }
    else if (type == "encode"){
        for (i = 1; i <= NF; ++i){
            iter = 1
            if ($i != $(i+1))
                res = res""$i
            else {
                while (i < NF && $i == $(i+1)){
                    letter = $i
                    ++iter
                    ++i
                }
            res = res""iter""letter
            }
        }
    }
    print res
}