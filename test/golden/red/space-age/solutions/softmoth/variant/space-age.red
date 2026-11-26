Red [
    description: {"Space Age" exercise solution for exercism platform}
    author: "softmoth"
]

seconds-per-earth-year: 31557600
planets: [
    "Mercury" 0.2408467
    "Venus" 0.61519726
    "Earth" 1.0
    "Mars" 1.8808158
    "Jupiter" 11.862615
    "Saturn" 29.447498
    "Uranus" 84.016846
    "Neptune" 164.79132
]

age: function [
    planet
    seconds
] [
    year-ratio: select planets planet
    round/to seconds / seconds-per-earth-year * year-ratio 0.01
]

