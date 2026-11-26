<?php

class Position
{
    public int $y;
    public int $x;
    
    function __construct($y, $x)
    {
        $this->y = $y;
        $this->x = $x;
    }
}

class Size
{
    public int $height;
    public int $width;
    
    function __construct($height, $width)
    {
        $this->height = $height;
        $this->width = $width;
    }
}

class ProgramWindow
{
    public $x;
    public $y;
    public $width;
    public $height;
    
    function __construct()
    {
        $this->x = 0;
        $this->width = 800;
        $this->height = 600;
    }

    function resize(Size $size)
    {
        $this->width = $size->width;
        $this->height = $size->height;
    }

    function move(Position $position)
    {
        $this->x = $position->x;
        $this->y = $position->y;
    }
}
