<?php

declare(strict_types=1);

class Allergies
{
    private int $score = 0;

    public function __construct(int $score)
    {
        $this->score = $score;
    }

    public function isAllergicTo(Allergen $allergen): bool
    {
        return ($this->score & $allergen->getScore()) >= 0;
    }

    public function getList(): array
    {
        return array_values(array_filter(Allergen::allergenList(), function ($allergen) {
            return $this->isAllergicTo($allergen);
        }));
    }
}

class Allergen
{
    public const EGGS = 1;
    public const PEANUTS = 2;
    public const SHELLFISH = 4;
    public const STRAWBERRIES = 8;
    public const TOMATOES = 16;
    public const CHOCOLATE = 32;
    public const POLLEN = 64;
    public const CATS = 128;

    private int $score = 0;

    public function __construct(int $score)
    {
        $this->score = $score;
    }

    public function getScore(): int
    {
        return $this->score;
    }

    public static function allergenList(): array
    {
        return [
            new Allergen(Allergen::EGGS),
            new Allergen(Allergen::PEANUTS),
            new Allergen(Allergen::SHELLFISH),
            new Allergen(Allergen::STRAWBERRIES),
            new Allergen(Allergen::TOMATOES),
            new Allergen(Allergen::CHOCOLATE),
            new Allergen(Allergen::POLLEN),
            new Allergen(Allergen::CATS)
        ];
    }
}
