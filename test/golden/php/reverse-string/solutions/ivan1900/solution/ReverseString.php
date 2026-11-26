<?php

declare(strict_types=1);

function reverseString(string $text): string
{
	$arrayText = array_reverse(str_split($text,1));
	
	return implode($arrayText);
}
