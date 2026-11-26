<?php
function detectAnagrams(string $word, array $candidates): array
{
    $word = mb_strtolower($word);
    $count = count_chars($word);
    return array_values(
        array_filter(
            $candidates,
            static function ($candidate) use ($word, $count) {
                $candidate = mb_strtolower($candidate);
                return $word !== $candidate && $count === count_chars($candidate);
            }
        )
    );
}
