<?php
declare(strict_types=1);
class DndCharacter
{
    private const ABILITIES = [
        'strength',
        'dexterity',
        'constitution',
        'intelligence',
        'wisdom',
        'charisma'
    ];
    private const MAGIC_NUMBER = 10;
    private const MIN_SUM_DICES = 3;
    private const MAX_SUM_DICES = 18;
    public static function ability(): int
    {
        return self::throwAndSumDices();
    }
    public static function generate(): stdClass
    {
        $character = new stdClass();
        foreach (self::ABILITIES as $ability) {
            $character->{$ability} = self::throwAndSumDices();
        }
        $character->hitpoints = self::MAGIC_NUMBER + self::modifier($character->constitution);
        return $character;
    }
    public static function modifier(int $input): int
    {
        return (int) floor(($input - self::MAGIC_NUMBER) / 2);
    }
    private static function throwAndSumDices(): int
    {
        return random_int(self::MIN_SUM_DICES, self::MAX_SUM_DICES);
    }
}
