<?php

declare(strict_types=1);

function toRna(string $dnaStrand): string
{
	return strtr($dnaStrand, 'CGTA', 'GCAU');
}
