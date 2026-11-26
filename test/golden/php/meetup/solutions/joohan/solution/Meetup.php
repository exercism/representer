<?php

declare(strict_types=1);

function meetup_day(int $year, int $month, string $which, string $weekday): DateTimeImmutable
{
    $dt = new DateTimeImmutable("{$year}/{$month}/01");

    return match ($which) {
        "teenth" => $dt->modify('+11 days')->modify("next {$weekday}"),
        default => $dt->modify("{$which} {$weekday} of this month"),
    };
}
