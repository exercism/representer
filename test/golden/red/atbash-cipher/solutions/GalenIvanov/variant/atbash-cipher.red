Red [
	description: {"Atbash Cipher" exercise solution for exercism platform}
	author: "Galen Ivanov"
]

letters: charset [#"a" - #"z"]	 
digits: charset [#"0" - #"9"]
allowed: union letters digits

substitute: func [char][either letters/:char [#"a" + #"z" + char][char]]

encode: function [phrase][
    spacer: 0
    collect/into [
    	foreach char lowercase copy phrase [
        	if allowed/:char [
                if spacer = 5 [
                	keep space
                    spacer: 0
                ]
            	keep substitute char
                spacer: spacer + 1
            ]
        ]
     ] copy ""
]

decode: function [phrase][
	collect/into [
    	foreach char phrase [
        	if char <> space [keep substitute char]
        ]
    ] copy ""
]