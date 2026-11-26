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
class SimpleCipher
{
    public function __construct(string $key = null)
    {
        if (is_null($key)) {
            $seed = str_split('abcdefghijklmnopqrstuvwxyz');
            shuffle($seed); // probably optional since array_is randomized; this may be redundant
            $rand = '';
            for ($i = 0; $i < 100; $i++) {
                $rand .= $seed[array_rand($seed, 1)];
            }
            $this->key = $rand;
        } else if (preg_match('/^[a-z]+$/', $key)) {
            $this->key = $key;
        } else {
            throw new InvalidArgumentException();
        }
    }

    public string $key;

    public function encode(string $plainText): string
    {
        for ($i = 0; $i < strlen($plainText); $i++){
            $shift = ord($this->key[$i % strlen($this->key)]) - 97;
            $plainText[$i] = chr(97 + ((ord($plainText[$i]) - 97 + $shift) % 26));
        }

        return $plainText;
    }

    public function decode(string $cipherText): string
    {
        for ($i = 0; $i < strlen($cipherText); $i++){
            $shift = ord($this->key[$i % strlen($this->key)]) - 97;
            $cipherText[$i] = chr(122 - ((122 - ord($cipherText[$i]) + $shift) % 26));
        }

        return $cipherText;
    }
}
