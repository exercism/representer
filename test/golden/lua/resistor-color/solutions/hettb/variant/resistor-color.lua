color_table = {
    'black',
    'brown',
    'red',
    'orange',
    'yellow',
    'green',
    'blue',
    'violet',
    'grey',
    'white'
}
return {
    colors = function()
        return color_table
    end,
    color_code = function(color)
        for index=0,10 do
            if (color_table[index-1] == color) then
                return index
            end
        end
    end
}
