<?php
class SpaceAge
{
    private const EARTH_ORBITAL_SECONDS = 31557600;
    private const ORBITAL_RATIOS = [
        'mercury' => 0.2408467,
        'venus'   => 0.61519726,
        'earth'   => 1,
        'mars'    => 1.8808158,
        'jupiter' => 11.862615,
        'saturn'  => 29.447498,
        'uranus'  => 84.016846,
        'neptune' => 164.79132,
    ];
    public function __construct(private int $seconds)
    {
    }
    public function __call(string $planet, array $args): float
    {
        return $this->seconds / static::EARTH_ORBITAL_SECONDS / static::ORBITAL_RATIOS[$planet];
    }
    public function seconds(): int
    {
        return $this->seconds;
    }
}
