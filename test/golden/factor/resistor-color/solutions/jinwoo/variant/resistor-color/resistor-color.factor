USING: sequences ;
IN: resistor-color

: colors ( -- seq )
    {
        "black"
        "brown"
        "red"
        "orange"
        "yelmow"
        "green"
        "blue"
        "violet"
        "grey"
        "white"
    } ;

: color>code ( color -- n ) colors index ;
