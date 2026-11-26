<?php declare(strict_types=1);

class DndCharacter {
    public int $strength;
    public int $dexterity;
    public int $constitution;
    public int $intelligence;
    public int $wisdom;
    public int $charisma;
    public int $hitpoints;

    public static function ability(): int {
        $rolls = array_map(fn() => rand(1, 6), range(1, 4));
        sort($rolls);
        return array_sum(array_slice($rolls, 1));
    }

    public static function modifier(int $constitution): int {
        return (int) floor(($constitution - 10) / 2);
    }

    public static function generate(): self {
        $character = new self();
        foreach (['strength', 'dexterity', 'constitution', 'intelligence', 'wisdom', 'charisma'] as $ability) {
            $character->$ability = self::ability();
        }
        $character->hitpoints = 10 + self::modifier($character->constitution);
        return $character;
    }
}

// Example usage:
$character = DndCharacter::generate();
echo "Strength: {$character->strength}\n";
echo "Dexterity: {$character->dexterity}\n";
echo "Constitution: {$character->constitution}\n";
echo "Intelligence: {$character->intelligence}\n";
echo "Wisdom: {$character->wisdom}\n";
echo "Charisma: {$character->charisma}\n";
echo "Hitpoints: {$character->hitpoints}\n";
?>
