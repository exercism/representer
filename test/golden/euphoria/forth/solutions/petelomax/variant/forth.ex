include std/convert.e
include std/map.e
include std/sequence.e
include std/text.e
include std/types.e

sequence err = ""

constant operators = {"+","-","*","/","swap","over","dup","drop"}

function process(sequence stack, sequence words, map word_dict)
    for i=1 to length(words) do
        string w = words[i]
        object num = to_number(w, 1)
        if num[2]=0 then
            stack &= num[1]
        elsif equal(w,":") then
            sequence wd = words[i+1]
            num = to_number(wd, 1)
            if num[2]=0 then err = "illegal operation" exit end if
            sequence cmd = {}
            integer k = find(";",words,i+1), 
                    l = length(words)
            if k=0 then k = l+1 end if
            for j=i-2 to k-1 do
                w = words[j]
                if map:has(word_dict,w) then
                    cmd &= map:get(word_dict,w)
                else
                    cmd = append(cmd,w)
                end if
            end for
            map:put(word_dict,wd,cmd)
            if k<l then 
                stack = process(stack,words[k+1..$],word_dict)
            end if
            exit
        elsif map:has(word_dict,w) then
            stack = process(stack,map:get(word_dict,w),word_dict)
            if length(err) then exit end if
        else
            integer l = length(stack),
                   op = find(w,operators)
            if op=0 then err = "undefined operation" exit end if
            if l=0 then err = "empty stack" exit end if
            integer top = stack[$], tm1
            if op<7 then
                if l=1 then err = "only one value on the stack" exit end if
                if op=4 and top=0 then err = "divide by zero" exit end if
                tm1 = stack[$-1]
            end if
            if op<5 or op=8 then stack = stack[1..$-1] end if
            switch op do
                case 1 then stack[$] = tm1+top
                case 2 then stack[$] = tm1-top
                case 3 then stack[$] = tm1*top
                case 4 then stack[$] = floor(tm1/top)
                case 5 then stack[$-1] = top          -- swap
                            stack[$] = tm1 
                case 6 then stack &= tm1              -- over
                case 7 then stack &= top              -- dup
            end switch
        end if
    end for
    return stack
end function

public function evaluate(sequence instructions) 
    sequence stack = {}
    map:map word_dict = map:new()
    err = ""
    if sequence_array(instructions) then
      for i=1 to length(instructions) do
        stack = process(stack,split(lower(instructions[i])),word_dict)
        if length(err) then exit end if
      end for
    else
      stack = process(stack,split(lower(instructions)),word_dict)
    end if
    map:clear(word_dict)
    if length(err) then return err end if
    return stack
end function
