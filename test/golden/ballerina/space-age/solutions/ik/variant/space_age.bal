type Planet record {|
   	readonly string name;
   	float ratio;
|};

table<Planet> key(name) planets = table [
    { name: "Mercury", ratio: 0.2408467 },
    { name: "Venus", ratio: 0.61519726 },
    { name: "Earth", ratio: 1 },
    { name: "Mars", ratio: 1.8808158 },
    { name: "Jupiter", ratio: 11.862615 },
    { name: "Saturn", ratio: 29.447498 },
    { name: "Uranus", ratio: 84.016846 },
    { name: "Neptune", ratio: 164.79132 }
];

function age(string name, int seconds) returns float|error {
    Planet? planet = planets[name];

    if planet is Planet {
        return (<=float>seconds / 31557600.0 / planet.ratio).round(2);
    }

    return error("not a planet");
}
