<?php

class ProgramWindow
{
    public $x;
    public $y;
    public $width;
    public $height;

    public function __construct()
    {
        $this->height = 600;
        $this->width = 800;
    }

    public function resize(Size $size)
    {
        $this->height = $size->height;
        $this->width = $size->width;
    }

    public function move(Position $position)
    {
        $this->y = $position->y;
        $this->x = $position->x;
    }
}

class Position
{
    public function __construct(int $y, int $x)
    {
        $this->y = $y;
        $this->x = $x;
    }
}

class Size
{
    public function __construct(int $height, int $width)
    {
        $this->height = $height;
        $this->width = $width;
    }
}