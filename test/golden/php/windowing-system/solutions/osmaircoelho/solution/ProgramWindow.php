<?php

class ProgramWindow
{
    public $x;
    public $y;
    public $width;
    public $height;

     function __construct($width = 800, $height = 600, $x = 0, $y = 0){
        $this->width = $width;
        $this->height = $height;
        $this->x = $x;
        $this->y = $y;
    }

     function resize(Size $size){
        $this->width = $size->width;
        $this->height = $size->height;
    }

    public function move(Position $position){
        $this->x = $position->x;
        $this->y = $position->y;
    }
}
