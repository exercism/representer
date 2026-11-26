def colors:
    ["black","brown","red","orange","yellow","green","blue","violet","grey","white"]
;

# input: (string) a color
# output: (integer) a color code
def colorCode:
    . as $code
    | colors
    | index($code)
;

# input: an array of 2 or 3 colors as strings
# output a numeric value decoded from the first two colors
def colorValue:
    (.[0] | colorCode) * 10 + (.[1] | colorCode)
;
