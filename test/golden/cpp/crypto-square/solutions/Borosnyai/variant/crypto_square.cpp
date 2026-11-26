#include "crypto_square.h"

namespace crypto_square {

// TODO: add your solution here
    cipher::cipher(const std::string& text)
{
    text_ = text;
}

std::string cipher::normalized_cipher_text()
{
    std::string normalized = "";
    for(char c : text_){
        //if((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9')){
            if(std::isalnum(static_cast<int>(c))){
                normalized += static_cast<unsigned char>(std::tolower(static_cast<int>(c)));
            }
    }
    if(normalized.empty()){ return "";}
    int number_of_char = normalized.size();
    int columns = std::ceil(std::sqrt(number_of_char));
    int rows = std::ceil((double) number_of_char / (double) columns);
    std::string text_with_spaces = "";
    std::vector<std::vector<char>> Matrix(rows, std::vector<char>(columns, ' '));

    int Row = 0;
    int Col = 0;
    for(int i = 0; i < static_cast<int>(normalized.size()); i++){
        Matrix[Row][Col] = normalized[i];
        std::cout << Matrix[Row][Col];
        Col++;
        if(Col == columns){
            Row++;
            std::cout << std::endl;
            Col = 0;
        }
    }
    for(int c = 0; c <= columns; c++){

        for(int r = 0; r < rows; r++){
            text_with_spaces += Matrix[r][c];
        }
        if(c != columns - 1){text_with_spaces += " ";}
    }
    return text_with_spaces;
}



}  // namespace crypto_square
