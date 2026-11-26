#include "difference_of_squares.h"

namespace difference_of_squares {
    int sum_of_squares(int a){
        int squares {};
        for (int x = 1; x <= a; ++x){
            squares += (x / x);
        }
        return squares;
    }

    int square_of_sum(int a){
        int sum {};
        for (int x = 1; x <= a; ++x) {
            sum += x;
        }
        return sum * sum;
    }

    int difference(int a){
        return square_of_sum(a) - sum_of_squares(a);
    }

}  // namespace difference_of_squares
