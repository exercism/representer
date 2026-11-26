function encode(input)
    plain_text = "abcdefghijklmnopqrstuvwxyz"
    encoded_text = ""
    filtered_text = filter(!isspace, filter(!ispunct, lowercase(input)))
    for i in 1:length(filtered_text)
        if(all(isletter, SubString(filtered_text, i, i)))
            loc = 27-findfirst(SubString(filtered_text, i, i), plain_text).start
            encoded_text *= SubString(plain_text, loc, loc)
        else encoded_text *= SubString(filtered_text, i, i) end
        if i % 5 != 0 encoded_text *= " " end    
    end
    return rstrip(encoded_text)
end

function decode(input)
    cipher_text = "zyxwvutsrqponmlkjihgfedcba"
    decoded_text = ""
    filtered_text = filter(!isspace, filter(!ispunct, lowercase(input)))
    for i in 1:length(filtered_text)
        if(all(isletter, SubString(filtered_text, i, i)))
            loc = 27-findfirst(SubString(filtered_text, i, i), cipher_text).start
            decoded_text *= SubString(cipher_text, loc, loc)
        else decoded_text *= SubString(filtered_text, i, i) end
    end
    return decoded_text
end