function encode(s)
    occursin(r"[^a-zA-Z ]",s) && error("wrong char in input")

    out = ""
    len = length(s)
    len < 2 ? (return s) : nothing
    cnt=1
    for i = 1:len-1
        if s[i] == s[i+1]
            cnt += 1
            continue
        end
        cnt == 1 ? out = out * s[i] : out = out * string(cnt) * s[i]
        cnt = 1 
    end
    cnt == 1 ? out = out * s[len] : out = out * string(cnt) * s[len]    # last index
    out
end



function decode(s)
    occursin(r"[^a-zA-Z0-9 ]",s) && error("wrong char in input")

    out = ""
    len = length(s)
    (len>0 && isdigit(s[len]) == true) && error("last char digit")
    len < 2 ? (return s) : nothing

    idx = 1
    while idx < len
        if isdigit(s[idx]) != true
            out = out * s[idx]
            idx +=1
        else
            cnt=0
            snum=""
            while isdigit(s[idx]) == true
                snum *= s[idx]
                cnt = parse(Int,snum)
                idx += 1
            end
            for j = 1:cnt-1
                out = out * s[idx]
            end
        end
    end
    out
end
