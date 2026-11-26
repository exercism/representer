<?php

class ProgramWindow
{
    public $y;
    public $x;
    public $width;
    public $height;

    function __construct() {
        $this->y = 0;
        $this->x = 0;
        $this->width = 800;
        $this->height = 600;
    }

    public function resize(Size $size) {
        $this->width = $size->width;
        $this->height = $size->height;
    }

    public function move($position) {
        $this->y = $position->y;
        $this->x = $position->x;
    }
}
