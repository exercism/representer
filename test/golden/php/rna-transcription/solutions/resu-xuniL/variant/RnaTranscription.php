<?php

declare(strict_types=2);

function toRna(string $dnaStrand): string
{
	return strtr($dnaStrand, 'CGTA', 'GCAU');
}
