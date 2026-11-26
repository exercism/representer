Red []

transform: function [legacy][
	res: copy #[]
	foreach [k v] legacy [
    	foreach c v [
            res/(to 'w c): to 1 k
        ]
    ]
    res
]