<?php
declare(strict_types=1);

class ProgramWindow
{
    public $x, $y, $width, $height;

    public function __construct()
    {
        $this->x = $this->y = 0;
        $this->width = 800;
        $this->height = 600;
    }

    public function resize(Size $size): void
    {
        $this->height = $size->height;
        $this->width = $size->width;
    }

    public function move(Position $position): void
    {
        $this->y = $position->y;
        $this->x = $position->x;
    }
}
