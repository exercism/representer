#include "queen_attack.h"
#include <cstdlib>
namespace queen_attack {
        bool chess_board::can_attack() const 
        {
            if((m_white.first == m_black.first) ||
                (m_white.second == m_black.second) ||
                (m_white.first - m_white.second == m_black.first - m_black.second)     ||
                (7 - m_white.first - m_white.second == 7 - m_black.first - m_black.second)
                )
                return true;
            else
                return false;
        }
        std::pair<int,int> chess_board::white() const { return m_white; }
        std::pair<int,int> chess_board::black() const { return m_black; }
}  // namespace queen_attack