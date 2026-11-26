Red [
	description: {"Yacht" exercise solution for exercism platform}
	author: "David82"
]

score: function [
    dice [block!]
    category [string!]
] [
    score: 0
    switch category [
        "ones" [foreach die dice [if die = 1 [score: score + 1]]]
        "twos" [foreach die dice [if die = 2 [score: score + 2]]]
        "threes" [foreach die dice [if die = 3 [score: score + 3]]]
        "fours" [foreach die dice [if die = 4 [score: score + 4]]]
        "fives" [foreach die dice [if die = 5 [score: score + 5]]]
        "sixes" [foreach die dice [if die = 6 [score: score + 6]]]
        
        "full house" [
            freq: collect [
                foreach die unique dice [
                    keep length? collect [foreach d dice [if d = die [keep d]]]
                ]
            ]
            if all [find freq 2 find freq 3 2 = length? freq] [score: sum dice]
        ]
        
        "four of a kind" [
            foreach die unique dice [
                cnt: length? collect [foreach d dice [if d = die [keep d]]]
                if cnt >= 4 [score: 4 * die break]
            ]
        ]
        
        "little straight" [
            if equal? sort dice [1 2 3 4 5] [score: 30]
        ]
        
        "big straight" [
            if equal? sort dice [2 3 4 5 6] [score: 30]
        ]
        
        "choice" [
            score: sum dice
        ]
        
        "yacht" [
            if 1 = length? unique dice [score: 50]
        ]
    ]
    
    return score
]
