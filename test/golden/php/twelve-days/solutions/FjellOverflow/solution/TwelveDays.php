<?php

declare(strict_types=1);

class TwelveDays
{
    public function recite(int $start, int $end): string
    {
        $output = self::line($start);
        if ($end > $start) {
            $output .= PHP_EOL;
        }
        for($i = $start + 1; $i < $end + 1; $i++){
            $output .= self::line($i);
            if ($i < $end) {
                $output .= PHP_EOL;
            }
        }
        return $output;
    }

    private static function line(int $number): string {
        $ordinal = self::ordinal($number);
        $items = self::getItems($number);
        return "On the {$ordinal} day of Christmas my true love gave to me: {$items}.";
    }

    private static function ordinal(int $number): string {
        $ordinals = [
            'first',
            'second',
            'third',
            'fourth',
            'fifth',
            'sixth',
            'seventh',
            'eighth',
            'ninth',
            'tenth',
            'eleventh',
            'twelfth'
        ];
        return $ordinals[$number - 1];
    }

    private static function getItems(int $number): string {
        $result = self::getItem($number);
        for($i = $number - 1; $i > 0; $i--) {
            $result .= ', ';
            if($i === 1 && $number > 1) {
                $result .= 'and ';
            }
            $result .= self::getItem($i);
        }
        return $result;
    }
    
    private static function getItem(int $number): string {
        $items = [
            'a Partridge in a Pear Tree',
            'two Turtle Doves',
            'three French Hens',
            'four Calling Birds',
            'five Gold Rings',
            'six Geese-a-Laying',
            'seven Swans-a-Swimming',
            'eight Maids-a-Milking',
            'nine Ladies Dancing',
            'ten Lords-a-Leaping',
            'eleven Pipers Piping',
            'twelve Drummers Drumming'
        ];
        return $items[$number - 1];
    }
}
