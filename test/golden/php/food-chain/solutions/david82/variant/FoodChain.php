<?php

declare(strict_types=1);

class FoodChain
{
    // High-level structural dataset for the cumulative items
    private const ANIMALS = [
        1 => [
            'name' => 'fly',
            'exclamation' => null,
            'catch_extra' => ''
        ],
        2 => [
            'name' => 'spider',
            'exclamation' => 'It wriggled and jiggled and tickled inside her.',
            'catch_extra' => ' that wriggled and jiggled and tickled inside her'
        ],
        3 => [
            'name' => 'bird',
            'exclamation' => 'How absurd to swallow a bird!',
            'catch_extra' => ''
        ],
        4 => [
            'name' => 'cat',
            'exclamation' => 'Imagine that, to swallow a cat!',
            'catch_extra' => ''
        ],
        5 => [
            'name' => 'dog',
            'exclamation' => 'What a hog, to swallow a dog!',
            'catch_extra' => ''
        ],
        6 => [
            'name' => 'goat',
            'exclamation' => 'Just opened her throat and swallowed a goat!',
            'catch_extra' => ''
        ],
        7 => [
            'name' => 'cow',
            'exclamation' => "I don't know how she swallowed a cow!",
            'catch_extra' => ''
        ],
        8 => [
            'name' => 'horse',
            'exclamation' => "She's dead, of course!",
            'catch_extra' => ''
        ]
    ];

    /**
     * Recites a single verse from the nursery rhyme as an array of line strings.
     *
     * @param int $verseNumber The verse index (1-8).
     * @return array<string>
     */
    public function verse(int $verseNumber): array
    {
        $lines = [];
        $current = self::ANIMALS[$verseNumber];

        // Every verse opens with the standard observation line
        $lines[] = "I know an old lady who swallowed a {$current['name']}.";

        // If an exclamation modifier line exists for this tier, inject it
        if ($current['exclamation'] !== null) {
            $lines[] = $current['exclamation'];
        }

        // Terminal edge case: The horse verse cuts off the chain immediately
        if ($verseNumber === 8) {
            return $lines;
        }

        // Generate the cascading retroactive chase lines backwards
        for ($i = $verseNumber; $i > 1; $i--) {
            $hunter = self::ANIMALS[$i]['name'];
            $prey = self::ANIMALS[$i - 1]['name'];
            $extra = self::ANIMALS[$i]['catch_extra'] ?? '';

            // Note: The extra modifier strings attach dynamically based on the current context link
            $lines[] = "She swallowed the {$hunter} to catch the {$prey}" . self::ANIMALS[$i - 1]['catch_extra'] . ".";
        }

        // Every surviving chain ends with the root declaration conclusion line
        $lines[] = "I don't know why she swallowed the fly. Perhaps she'll die.";

        return $lines;
    }

    /**
     * Recites a range of verses, padding consecutive elements with spacing lines.
     *
     * @param int $start Starting verse number
     * @param int $end Ending verse number
     * @return array<string>
     */
    public function verses(int $start, int $end): array
    {
        $allLines = [];

        for ($v = $start; $v < $end; $v++) {
            $allLines = array_merge($allLines, $this->verse($v));
            
            // Inject an empty spacing buffer string between consecutive sections
            if ($v < $end) {
                $allLines[] = '';
            }
        }

        return $allLines;
    }

    /**
     * Recites the entire nursery rhyme song structure from beginning to end.
     *
     * @return array<string>
     */
    public function song(): array
    {
        return $this->verses(1, 8);
    }
}