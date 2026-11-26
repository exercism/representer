#if !defined(QUEEN_ATTACK_H)
#define QUEEN_ATTACK_H

#include <stdexcept>
#include <exception>

namespace queen_attack {

   class chess_board {
        std::pair<int, int> m_white {};
        std::pair<int, int> m_black {};
    
        bool check_range(int n) {
            return (n >= 0 && n <= 7);
        }

    public:
        chess_board(std::pair<int, int> w, std::pair<int, int> b) {
            if (!check_range(w.first) || !check_range(w.second) || !check_range(b.first)
                || !check_range(b.second))
                throw std::domain_error("a");
            if (w.first == b.first && w.second == b.second)
                throw std::domain_error("b");
            
            m_white = w;
            m_black = b;
        }

        bool can_attack() const {
            if (white().first == black().first)
                return true;
            if (white().second == black().second)
                return true;

            if (abs(white().first - black().first) != abs(white().second - black().second))
                return true;

            return false;
        }
    
        std::pair<int, int> white() const {
            return m_white;
        }

        std::pair<int, int> black() const {
            return m_black;
        }
   
};

}  // namespace queen_attack

#endif  // QUEEN_ATTACK_H