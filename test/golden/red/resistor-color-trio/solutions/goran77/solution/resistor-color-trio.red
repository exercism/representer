Red [
	description: {"Resistor Color Trio" exercise solution for exercism platform}
	author: "" ; you can write your name here, in quotes
]

label: function [colors] 
[
	color2num: ["black" 0
    			"brown" 1
                "red" 2
                "orange" 3
                "yellow" 4
                "green" 5
                "blue" 6
                "violet" 7
                "grey" 8
                "white" 9]
    
	d1: 10 * select color2num colors/1
    d2: select color2num colors/2
    zeros: select color2num colors/3

    ohms: d1 + d2
    
    if d2 = 0 [
    	zeros: zeros + 1
    	ohms: d1 / 10
    ]

	case 
    [
		zeros >= 9 [ohms: ohms * power 10 (zeros - 9) unit: "gigaohms"]
        zeros >= 6 [ohms: ohms * power 10 (zeros - 6) unit: "megaohms"]
        zeros >= 3 [ohms: ohms * power 10 (zeros - 3) unit: "kiloohms"]
        zeros < 3  [ohms: ohms * power 10 zeros unit: "ohms"]
    ]
    
    result: ['value ohms 'unit unit]
    
    make map! reduce result
]
