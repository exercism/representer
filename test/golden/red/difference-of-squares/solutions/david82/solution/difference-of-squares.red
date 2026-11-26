Red [
    description: {"Difference of Squares" exercise solution for exercism platform"}
    author: "David82"
]

square-of-sum: function [
    number[integer!]
    return: [integer!]
] [
    sum: (number * (number + 1)) / 2
    return sum ** 2
]

sum-of-squares: function [
    number[integer!]
    return: [integer!]
] [
    return (number * (number + 1) * (2 * number + 1)) / 6
]

difference-of-squares: function [
    number[integer!]
    return: [integer!]
] [
    return subtract square-of-sum number sum-of-squares number
]
