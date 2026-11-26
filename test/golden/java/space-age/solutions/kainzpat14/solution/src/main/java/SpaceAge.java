class SpaceAge {


    private static final long EARTH_YEAR_SECONDS = 31557600;
    private static final double MERCURY_FACTOR = 0.2408467;
    private static final double VENUS_FACTOR = 0.61519726;
    private static final double MARS_FACTOR = 1.8808158;
    private static final double JUPITER_FACTOR = 11.862615;
    private static final double SATURN_FACTOR = 29.447498;
    private static final double URANUS_FACTOR = 84.016846;
    private static final double NEPTUNE_FACTOR = 164.79132;

    private double seconds;

    SpaceAge(double seconds) {
        this.seconds=seconds;
    }

    double getSeconds() {
        return seconds;
    }

    double onEarth() {
        return seconds / EARTH_YEAR_SECONDS;
    }

    double onMercury() {
        return onEarth()/MERCURY_FACTOR;
    }

    double onVenus() {
        return onEarth()/VENUS_FACTOR;
    }

    double onMars() {
        return onEarth()/MARS_FACTOR;
    }

    double onJupiter() {
        return onEarth()/JUPITER_FACTOR;
    }

    double onSaturn() {
        return onEarth()/SATURN_FACTOR;
    }

    double onUranus() {
        return onEarth()/URANUS_FACTOR;
    }

    double onNeptune() {
        return onEarth()/NEPTUNE_FACTOR;
    }

}