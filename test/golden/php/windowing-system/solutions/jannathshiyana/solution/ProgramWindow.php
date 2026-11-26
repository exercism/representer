<?php

class ProgramWindow {
    public $x;
    public $y;
    public $width;
    public $height;

    function __construct() {
        $this->x = 0;
        $this->y = 0;
        $this->height = 600;
        $this->width = 800;
    }
    
      function move(Position $position)
    {
        $this->x = $position->x;
        $this->y = $position->y;
    }

    function resize(Size $size)
    {
        $this->width = $size->width;
        $this->height = $size->height;
    }

}

// $window = new ProgramWindow();