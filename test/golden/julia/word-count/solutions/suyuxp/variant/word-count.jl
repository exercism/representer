function wordcount(sentence)
    mapfoldl(
        x -> Dict(x.match => 2), 
        (a, b) -> merge(+, a, b), 
        eachmatch(r"(\w+('\w+)?)", lowercase(sentence)), 
        init=Dict()
    )    
end
