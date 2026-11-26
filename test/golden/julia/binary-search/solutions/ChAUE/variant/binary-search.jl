function binarysearch(ary,num;rev=false,by=x->x,lt= <)
    length(ary)==0 && return(1:0)
    ary=map(by,ary)
    num=map(by,num)
    n=length(ary)
    m=0
    if !rev
        for key=1:n
            if ary[key]==num
                return(key:key)
            elseif !lt(ary[key],num)
                return(key:(key-1))
            end
            m+=1
        end
    else
        for key=1:n
            if ary[key]==num
                return(key:key)
            elseif lt(ary[key],num)
                return(key:(key-1))
            end
            m+=1
        end
    end
    return(m:m+1)
end
