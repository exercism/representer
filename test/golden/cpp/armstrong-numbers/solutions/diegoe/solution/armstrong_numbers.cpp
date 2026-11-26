#include "armstrong_numbers.h"
#include "iostream"
#include "string"

namespace armstrong_numbers {
    bool is_armstrong_number(int number)
    {
        int workingnumber = number;
        bool finish = false;
        int armstrongnumber = 0;
        int individualnumber = 0;
        bool validarmstrongnumber = false;
        int finishcounter = 0;
        
        while(!finish)
        {
            if(0 != workingnumber)  
            {
                finishcounter++;
                workingnumber = workingnumber/10;
            }
            else
            {
                finish = true;
            }
        }
        workingnumber = number;
        for(int i=0; i<finishcounter; i++)
        {
            if(0 == workingnumber)
            {
                finish = true;
                i=finishcounter;
            }
            else
            {
                individualnumber = workingnumber;
                workingnumber = workingnumber/10;
                if(workingnumber != 0)
                {
                    individualnumber = individualnumber-workingnumber*10;
                }
                else
                {
                    /* do nothing */
                }
                armstrongnumber = armstrongnumber + (pow(individualnumber, finishcounter));
            }
        }
        if(armstrongnumber == number)
        {
            validarmstrongnumber = true;
        }
        else
        {
            validarmstrongnumber = false;
        }
        return validarmstrongnumber;
    }
}  // namespace armstrong_numbers
