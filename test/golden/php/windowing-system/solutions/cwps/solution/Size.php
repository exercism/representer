<?php
declare(strict_types=1);

class Size
{
    public $height, $width;

    public function __construct($height, $width)
    {
        $this->height = $height;
        $this->width = $width;
    }
}
