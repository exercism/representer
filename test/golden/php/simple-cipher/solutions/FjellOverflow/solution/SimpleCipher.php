<?php

declare(strict_types=1);

class SimpleCipher
{
    public string $key;
    private static array $alphabet = [
        0 => 'a',
        1 => 'b',
        2 => 'c',
        3 => 'd',
        4 => 'e',
        5 => 'f',
        6 => 'g',
        7 => 'h',
        8 => 'i',
        9 => 'j',
        10 => 'k',
        11 => 'l',
        12 => 'm',
        13 => 'n',
        14 => 'o',
        15 => 'p',
        16 => 'q',
        17 => 'r',
        18 => 's',
        19 => 't',
        20 => 'u',
        21 => 'v',
        22 => 'w',
        23 => 'x',
        24 => 'y',
        25 => 'z',
    ];
    
    public function __construct(string $key = null)
    {
        if ($key === '') {
            throw new InvalidArgumentException();
        }
        if ($key === null) {
            $key = self::generateRandomKey();
        }
        if (preg_replace("/[^a-zA-Z]/", "", $key) !== $key || strtolower($key) !== $key) {
            throw new InvalidArgumentException();
        }
        $this->key = $key;
    }

    private static function generateRandomKey(): string {
        $key = '';
        while(strlen($key) < 100) {
            $key = $key . chr(rand(97, 122));
        }
        return $key;
    }

    private static function charToVal(string $char): int {
        return array_search($char, self::$alphabet);
    }

    private static function valToChar(int $val): string {
        while($val < 0) {
            $val += 26;
        }
        $val = $val % 26;
        return self::$alphabet[$val];
    }
    
    public function encode(string $plainText): string
    {
        $cipherText = '';
        for ($i = 0; $i < strlen($plainText); $i++) {
            $keyLetterVal = self::charToVal($this->key[$i]);
            $plainTextLetterVal = self::charToVal($plainText[$i]);
            $newLetter = self::valToChar($plainTextLetterVal + $keyLetterVal);
            $cipherText = $cipherText . $newLetter;
        }
        return $cipherText;
    }

    public function decode(string $cipherText): string
    {
        $plainText = '';
        for ($i = 0; $i < strlen($cipherText); $i++) {
            $keyLetterVal = self::charToVal($this->key[$i]);
            $cipherTextLetterVal = self::charToVal($cipherText[$i]);
            $newLetter = self::valToChar($cipherTextLetterVal - $keyLetterVal);
            $plainText = $plainText . $newLetter;
        }
        return $plainText;
    }
}
