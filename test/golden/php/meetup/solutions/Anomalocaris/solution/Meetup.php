<?php

declare(strict_types=1);

function meetup_day(int $year, int $month, string $which, string $weekday): DateTimeImmutable {
    $date = new DateTimeImmutable("{$year}/{$month}/01");

    return match ($which) {
        "teenth" => $date->modify('+11 days')->modify("next {$weekday}"),
        default => $date->modify("{$which} {$weekday} of this month"),
    };
}
