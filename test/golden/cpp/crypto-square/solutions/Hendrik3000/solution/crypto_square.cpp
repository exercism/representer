#include "crypto_square.h"
#include <cmath>
#include <algorithm>

namespace crypto_square {

std::string cipher::normalize_plain_text(){
    std::string text;
    
    std::copy_if(input_str.begin(), input_str.end(), std::back_inserter(text), isalnum);
    std::transform(text.begin(), text.end(), text.begin(), tolower);
    
    return text;
}

std::vector<std::string> cipher::plain_text_segments(){
    std::string str = normalize_plain_text();
    std::vector<std::string> chunks;
    
    rows = cols = std::round(std::sqrt(str.size()));
    if(rows * cols < str.size()) cols++;
    
    for(size_t i = 0; i < str.size(); i += cols)
        chunks.emplace_back(str.substr(i, cols));
    
    return chunks;
}
std::string cipher::cipher_text(){
    std::vector<std::string> chunks = plain_text_segments();
    std::string result;
    
    for(size_t i = 0; i < cols; i++){
        for(const std::string& k : chunks)
            if(k.size() > i)
                result += k.at(i);
    }
    return result;
}


std::string cipher::normalized_cipher_text(){
    std::string result = cipher_text();
    
    const size_t diff = rows * cols - result.size();
    for(size_t i = 0; i < diff; i++)
        result.insert(result.size() - i * rows, " ");
    
    for(size_t i = rows; i < cols * rows; i += rows + 1)
        result.insert(i, " ");

    return result;
}

}  // namespace crypto_square
