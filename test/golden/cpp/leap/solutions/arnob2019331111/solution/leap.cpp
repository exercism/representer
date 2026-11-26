#include "leap.h"

using namespace std;

namespace leap{
    bool is_leap_year(int year) {
        return (!(year % 4) && (year % 100)) || (!(year % 400));

        //Previous Solution:

        // return year % 4 == 0 ? (year % 100 == 0 ? (year % 400 == 0 ? true : false) : true) : false;

        // OR

        // if (year % 4 == 0) {
        //     if (year % 100 == 0) {
        //         if (year % 400 == 0) return true;
        //         return false;
        //     } 
        //     return true;
        // } return false;

    }

} // namespace leap
