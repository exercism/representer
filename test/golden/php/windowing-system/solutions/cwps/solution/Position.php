<?php
declare(strict_types=1);

class Position
{
    public $x, $y;

    public function __construct($y, $x)
    {
        $this->y = $y;
        $this->x = $x;
    }
}
