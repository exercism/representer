# Change any of the following NamedTuple values to true to 
# enable testing different bonus tasks
tested_benus_tasks = (rev = false, by = false, lt = false, multiple_matches = false)


function binarysearch(a::Vector, x)
    indx = cld(length(a),2)
    offs = 0
    match = false
    while(indx > 0)
        val = a[offs+indx]
        #println("indx :", indx, "  offs :", offs, "  val =", val)
        if val == x
            match = true 
            break
        end
        if val < x 
            offs += indx
        end
        indx = fld(indx,2)
    end
    if match == true
        offs+indx : offs+indx
    else
        offs+indx : offs+indx-1
    end
end