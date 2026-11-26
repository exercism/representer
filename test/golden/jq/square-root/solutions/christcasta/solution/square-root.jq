def getRoot:
    def rec($target):
        if .[0] * .[0] == $target then
            .[0]
        else 
            .[1:] | rec($target)
        end;
    . as $target
    | [range(0, $target + 1)] 
    | rec($target)
;
.radicand
| getRoot