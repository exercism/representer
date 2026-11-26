<?php


declare(strict_types=1);

class RobotFactory
{
    private static $outdatedNames = [];

    private static function randomLetters($max = 2) : string
    {
        $chars = range("a", "z");
        for ($i = 0; $i < $max; $i++) {
            $rnd = array_rand($chars, 2);
            $string = $chars[$rnd[0]] . $chars[$rnd[1]];
        }
        return strtoupper($string);
    }

    private static function randomDigits($max = 3) : string
    {
        $chars = range(0, 9);
        for ($i = 0; $i < $max; $i++) {
            $rnd = array_rand($chars, 3);
            $string = implode('', $rnd);
        }
        return $string;
    }

    public static function randomName() : string
    {
        $name = self::randomLetters() . self::randomDigits();
        
        if(in_array($name, self::$outdatedNames)){
            return self::randomName();
        }

        self::$outdatedNames[] = $name;

        return $name;
    }
        
}

class Robot
{
    private $actualName = null;

    public function getName() : string
    {
        if($this->actualName === null){
            $this->actualName = RobotFactory::randomName();
        }

        return $this->actualName;
    }

    public function reset(): void
    {
        $this->actualName = null;
    }
    
}
