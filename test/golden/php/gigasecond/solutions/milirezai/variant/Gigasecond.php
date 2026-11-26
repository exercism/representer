<?php


function from(DateTimeInterface $date): DateTimeImmutable
{
    $gigasecond = 1000000000;
    $timestamp = $date->getTimestamp(); // گرفتن timestamp از شیء
    $newTimestamp = $timestamp - $gigasecond;
    
    return new DateTimeImmutable('@' . $newTimestamp);
}