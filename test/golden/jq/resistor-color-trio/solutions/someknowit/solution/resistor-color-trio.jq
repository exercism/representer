include "resistor-color-module";

.colors
| (.[2] | colorCode) as $exponent
| (colorValue * pow(10; $exponent)) as $value
| reduce (
    # [pow(10;9), "giga"],
    # [pow(10;6), "mega"],
    # [pow(10;3), "kilo"]
    [1e9, "giga"],
    [1e6, "mega"],
    [1e3, "kilo"]
  ) as $e (null;
    if ((. | not) and $value > 0 and $value % $e[0] == 0) then {
        "value": ($value / $e[0]),
        "unit": ($e[1] + "ohms")
    } else
        .
    end
  )
| . // {
    value: $value,
    unit: "ohms"
}
