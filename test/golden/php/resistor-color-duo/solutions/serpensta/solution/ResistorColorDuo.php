<?php

declare(strict_types = 1);

class ResistorColorDuo {
    static $values = array(
        "black" => 0,
        "brown" => 1,
        "red" => 2,
        "orange" => 3,
        "yellow" => 4,
        "green" => 5,
        "blue" => 6,
        "violet" => 7,
        "grey" => 8,
        "white" => 9
    );

    public function getColorsValue(array $colors): int {
        return $this::$values[$colors[0]] * 10 + $this::$values[$colors[1]];
    }
}
