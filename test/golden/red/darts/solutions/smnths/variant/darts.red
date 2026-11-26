Red [
	description: {"Darts" exercise solution for exercism platform}
	author: "smnths"
]

norm: function [
    x [number!]
    y [number!]
] [
    sqrt (x * x) + (y * y)
]

score: function [
	x [number!]
	y [number!]
] [
    radius-score-table: #[
        1 10
        5 5
        10 1
    ]

    foreach [rad sc] radius-score-table [
        if rad > norm x y [
            return sc
        ]
    ]

    return 0
]

