<?php

declare(strict_types=1);

function parse_binary(string $binary): int
{
	if (!preg_match('/^[01]+$/', $binary)) {
		throw new InvalidArgumentException();
	}
    $num = str_split(strrev($binary));
	$sum = 0;
	for ($i = 0; $i < count($num); $i++) {
		$sum += $num[$i] * (2 ** $i);
	}
	return $sum;
}
