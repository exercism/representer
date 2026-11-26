<#
.SYNOPSIS
Implement a simple shift cipher like Caesar and a more secure substitution cipher.

.DESCRIPTION
Implement a simple cipher class to encode or decode a message with a key.
If there was no key provided, generate one minumum 100 characters long contains only lower case letter (a-z).

.EXAMPLE
$cipher = [SimpleCipher]::new("mykey")

$cipher.Encode("aaaaa")
Return: "mykey"

$cipher.Decode("ecmvcf")
Return: "secret"
#>

Class SimpleCipher {
    [string]$_key
    [array]$_keyAsOffsetArray

    SimpleCipher() {
        $this._key = -join ((1..100) | ForEach-Object {[char]((97..122) | Get-Random  )})
        $this._keyAsOffsetArray = $this._key.ToCharArray() | ForEach-Object { $_ - [byte][char]'a' }
    }

    SimpleCipher([string]$key) {
        $this._key = $key
        $this._keyAsOffsetArray = $this._key.ToCharArray() | ForEach-Object { $_ - [byte][char]'a' }
    }

    [char] EncodeOneChar([char]$c, $pos) {
        #return [char]'a' + ($c - [char]'a' + ([char]($this._key[$pos % $this._key.Length]) - [char]'a')) % 26
        return [byte][char]'a' + ($c - [char]'a' + $this._keyAsOffsetArray[$pos % $this._key.Length]) % 26
    }

    [string] Encode([string]$clearText) {
        return -join ((0..($clearText.Length - 1)) | ForEach-Object { $this.EncodeOneChar($clearText[$_], $_) } )
    }

    [char] DecodeOneChar([char]$c, $pos) {
        return [byte][char]'a' + ($c - [char]'a' + 26 - $this._keyAsOffsetArray[$pos % $this._key.Length]) % 26
    }

    [string] Decode([string]$cipherText) {
        return -join ((0..($cipherText.Length - 1)) | ForEach-Object { $this.DecodeOneChar($cipherText[$_], $_) } )
    }
}