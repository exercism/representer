#include "difference_of_squares.h"

namespace difference_of_squares 
{
    int square_of_sum(int number)
    {
        // input and output variables are defined and initialized with 0
        int output {}; 
        // Using formula which gives sum of N numbers ( N * N+1 / 2)
        output = (number * (number -1))/2;
        
        return output * output;
    }
    int sum_of_squares(int number)
    {
        // input and output variables are defined and initialized with 0        
        int output {0}; 
        // Using formula which gives square of first  N numbers ((N * (N+1) * (2N+1))/6
         output = (number * (number +1) * (2*number+1))/6;
             
        return output;
    }
    int difference(int number)
    {
        // Calling above 2 functions to find the difference 
        return square_of_sum(number) -sum_of_squares(number);
    }
}  // namespace difference_of_squares
