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
    public $key;
    private $alph = "abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz";
    public function __construct(string $key = null)
    {
        if ($key === null)
            $this->key = $this->generateRandomString();
        else if (ctype_upper($key) || is_numeric($key) || $key === '')
            throw new InvalidArgumentException();
        else
            $this->key = $key;
    }

    public function encode(string $plainText): string
    {
        $result = "";
        for ($i = 0; $i < strlen($plainText); $i++){
            $shift = strpos($this->alph, $this->key[$i]);
            $result .=  $this->alph[strpos($this->alph, $plainText[$i]) + $shift];
        }
        return $result;
    }

    public function decode(string $cipherText): string
    {
        $result = "";
        for ($i = 0; $i < strlen($cipherText); $i++){
            $shift = strpos($this->alph, $this->key[$i]);
            $result .=  $this->alph[strpos($this->alph, $cipherText[$i]) - $shift];
        }
        return $result;
    }

    function generateRandomString($length = 100): string
    {
        $alph = "abcdefghijklmnopqrstuvwxyz";
        $charactersLength = strlen($alph);
        $randomString = '';
        for ($i = 0; $i < $length; $i++) {
            $randomString .= $alph[rand(0, $charactersLength - 1)];
        }
        return $randomString;
    }
}