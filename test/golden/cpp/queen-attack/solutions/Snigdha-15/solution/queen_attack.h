#if !defined(QUEEN_ATTACK_H)
#define QUEEN_ATTACK_H
#include <functional>
#include <stdexcept>

namespace queen_attack {
    class chess_board{
        public:
        chess_board(std::pair<int,int> white, std::pair<int,int> black):m_white(white), m_black(black){
            if(m_white.first < 0 || m_white.first >7 || 
               m_white.second < 0 || m_white.second >7 ||
               m_black.first < 0 || m_black.first >7 ||
               m_black.second < 0 || m_black.second >7 ||
                (m_black.second == m_white.second && m_black.first == m_white.first)
                )
                throw std::domain_error("invalid value");
        }
        bool can_attack()const;
        std::pair<int,int> white() const;
        std::pair<int,int> black() const;
private:
        std::pair<int,int> m_white;
        std::pair<int,int> m_black;
        
    };
}  // namespace queen_attack
#endif // QUEEN_ATTACK_H