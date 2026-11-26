<?php

declare(strict_types=1);

class Robot
{
    private string $name;
    private static array $robotNames = [];

    public function __construct() {
        $this->name = self::generateName();
    }

    private static function generateName() {
        $name = '';
        while(in_array($name, self::$robotNames) || $name === '') {
            $name = self::randomLetter() . self::randomLetter() . rand(0, 9) . rand(0, 9) . rand(0, 9);
        }
        array_push(self::$robotNames, $name);
        return $name;
    }
    
    public function getName(): string
    {
        return $this->name;
    }

    private static function randomLetter(): string {
        return chr(rand(65, 90));
    }

    public function reset(): void
    {
        $this->name = self::generateName();
    }
}
