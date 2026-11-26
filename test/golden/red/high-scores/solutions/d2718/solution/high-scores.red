Red [
    description: {"High Scores" exercise solution for exercism platform}
    author: "Dan (d2718)"
]

scores: function [
    scores
] [
    scores
]

latest: function [
    scores
] [
    last scores
]

personal-best: function [
    scores
] [
    first sort/reverse copy scores
]

personal-top-three: function [
    scores
] [
    take/part sort/reverse copy scores 3
]
