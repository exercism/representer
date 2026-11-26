<?php

class ProgramWindow
{
    public $x;
    public $y;
    public $height;
    public $width;

    public function __construct()
    {
        $this->x = 0;
        $this->y = 0;
        $this->height = 600;
        $this->width = 800;
    }

    public function resize(Size $size)
    {
        $this->width = $size->width;
        $this->height = $size->height;
    }

    public function move(Position $pos)
    {
        $this->y = $pos->y;
        $this->x = $pos->x;
    }
}
