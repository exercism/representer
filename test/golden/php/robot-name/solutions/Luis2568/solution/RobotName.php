<?php

/*
 * By adding type hints and enabling strict type checking, code can become
 * easier to read, self-documenting and reduce the number of potential bugs.
 * By default, type declarations are non-strict, which means they will attempt
 * to change the original type to match the type specified by the
 * type-declaration.
 *
 * In other words, if you pass a string to a function requiring a float,
 * it will attempt to convert the string value to a float.
 *
 * To enable strict mode, a single declare directive must be placed at the top
 * of the file.
 * This means that the strictness of typing is configured on a per-file basis.
 * This directive not only affects the type declarations of parameters, but also
 * a function's return type.
 *
 * For more info review the Concept on strict type checking in the PHP track
 * <link>.
 *
 * To disable strict typing, comment out the directive below.
 */

declare(strict_types=1);

class Robot
{
    private static array $names = [];
    private string $name;
    public function getName(): string
    {
        if (!isset($this->name)) {
            $this->setRandomName();
        }
        return $this->name;
    }
    private function setRandomName(): void
    {
        do {
            $this->name = $this->randomName();
        } while (isset(self::$names[$this->name]));
        self::$names[$this->name] = true;
    }
    public function reset(): void
    {
        unset($this->name);
    }
    private function randomName(): string
    {
        return $this->randomUppercaseLetters(2) . $this->randomDigits(3);
    }
    private function randomUppercaseLetters(int $count): string
    {
        return $this->randomCharacters($count, 'A', 'Z');
    }
    private function randomDigits(int $count): string
    {
        return $this->randomCharacters($count, '0', '9');
    }
    private function randomCharacters(int $count, string $min, string $max): string
    {
        return implode(array_map(fn($x) => chr(rand(ord($min), ord($max))), array_fill(0, $count, null)));
    }
}