<?php

declare(strict_types=1);

function placeQueen(int $xCoordinate, int $yCoordinate): bool
{
   if ($xCoordinate < 0 || $yCoordinate < 0){
     throw new InvalidArgumentException("The rank and file numbers must be positive.");
   }
   if ($xCoordinate >= 0 && $xCoordinate <= 7){
      if ($yCoordinate >= 0 && $yCoordinate <= 7){
          return true;
      }
   }   
   throw new InvalidArgumentException("The position must be on a standard size chess board.");
   return false;
}

function canAttack(array $whiteQueen, array $blackQueen): bool
{
    if ($whiteQueen[0] === $blackQueen[0]){
       return true;
    }
    if ($whiteQueen[1] === $blackQueen[1]){
        return true;
    }
    if (onDiagnol($whiteQueen, $blackQueen)){
        return true;
    }
    return false;
    
}

function onDiagnol(array $whiteQueen, array $blackQueen): bool {
     return abs($blackQueen[1] - $whiteQueen[1]) === abs($blackQueen[0] - $whiteQueen[0]);

    return abs(($blackQueen[1] - $whiteQueen[1]) / ($blackQueen[0] - $whiteQueen[0])) === 1;
}