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
    private static array $nameList = [];
    private string $name = '';

    private function generateName(): string {
       return chr(random_int(0, 25) + 65) 
            . chr(random_int(0, 25) + 65)
            . random_int(1, 9) 
            . random_int(1, 9) 
            . random_int(1, 9);
    }

    private function setNewName(): void {
        while (strlen($this->name) !== 0) {
            $name = $this->generateName();
            if (!in_array($name, self::$nameList)) {
                $this->name = $name;
                array_push(self::$nameList, $name);
            }
        }
    }

    public function getName(): string {
        $this->setNewName();
        
        return $this->name;
    }

    public function reset(): void
    {
        $this->name = '';
    }
}