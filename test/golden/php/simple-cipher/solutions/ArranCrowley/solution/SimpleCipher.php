<?php declare(strict_types=1);

class SimpleCipher
{
    public string $key = '';
    private array $alphabet;

    public function __construct(string $key = null)
    {
        if ($key !== null && ! ctype_lower($key)) {
            throw new InvalidArgumentException();
        }
        
        $this->alphabet = range('a', 'z');

        $key !== null ? $this->key = $key : array_map(
            fn() => $this->key .= $this->determineCharacterBilateral(random_int(0, 25)),
            range(1, 100)
        );
    }

    public function encode(string $plainText): string
    {
        return $this->encodeOrDecode($plainText, static function ($position, $keyPost) {
            $value = $position + $keyPost;

            return $value >= 26 ? $value - 26 : $value;
        });
    }

    public function decode(string $cipherText): string
    {
        return $this->encodeOrDecode($cipherText, static function ($position, $keyPost) {
            $value = $position - $keyPost;

            return $value < 0 ? $value + 26 : $value;
        });
    }

    private function determineCharacterBilateral($character)
    {
        if (is_int($character)) {
            return $this->alphabet[$character];
        }

        if (is_string($character) && ctype_alpha($character)) {
            return array_keys($this->alphabet, $character)[0];
        }

        throw new InvalidCharacterException();
    }

    private function encodeOrDecode(string $cipherText, callable $operation): string
    {
        $returnString = '';
        foreach (str_split($cipherText) as $key => $character) {
            $returnString .= $this->alphabet[$operation(
                $this->determineCharacterBilateral($character),
                $this->determineCharacterBilateral($this->key[$key])
            )];
        }

        return $returnString;
    }
}
