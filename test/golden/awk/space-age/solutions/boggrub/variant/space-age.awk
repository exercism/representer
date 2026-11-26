function year (seconds, period) {
    return seconds / 31557600 * period
}

BEGIN {
    FS = " "
    planets["Mercury"]  = 0.2408467;    planets["Jupiter"] = 11.862615
    planets["Venus"]    = 0.61519726;   planets["Saturn"]  = 29.447498
    planets["Earth"]    = 1.0;          planets["Uranus"]  = 84.016846
    planets["Mars"]     = 1.8808158;    planets["Neptune"] = 164.79132
}

($1 in planets) != 1 {
    print "not a planet"
    exit(1)
}

{
    printf("%.2f\n", year($2, planets[$1]))
}
