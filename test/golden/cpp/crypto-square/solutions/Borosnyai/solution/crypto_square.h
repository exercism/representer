#pragma once
#include <string>
#include <cmath>
#include <vector>
#include <iostream>
namespace crypto_square {

// TODO: add your solution here

    class cipher{
    private:
        std::string text_;

    public:
      std::string normalized_cipher_text();
      cipher(const std::string& text);


    };

}  // namespace crypto_square
