<?php

declare(strict_types=1);

class ResistorColorTrio
{
    public function label(array $colors): string
    {
        $all_colors = [
            "black",
            "brown",
            "red",
            "orange",
            "yellow",
            "green",
            "blue",
            "violet",
            "grey",
            "white"
        ];

        $count = 0;
        $sum = 0;

        foreach ($colors as $color) {
            if ($count >= 2) { 
                $value = $sum * pow(10, array_search($color, $all_colors));
                return $this->formatValue($value);
            }

            $sum *= 10;
            $sum += array_search($color, $all_colors);
            $count++;
        }

        return ''; 
    }

    private function formatValue(int $value): string
    {    
        if ($value >= 1_000_000_000) {
            return sprintf("%d gigaohms", $value / 1_000_000_000);
        }
        else if ($value >= 1_000_000) {
            return sprintf("%d megaohms", $value / 1_000_000);
        }
        else if ($value >= 1_000) {
            return sprintf("%d kiloohms", $value / 1_000);
        } 
        else {
            return sprintf("%d ohms", $value);
        }
    }
}