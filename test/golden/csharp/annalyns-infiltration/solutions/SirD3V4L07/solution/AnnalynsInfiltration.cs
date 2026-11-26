using System;

static class QuestLogic
{
    public static bool CanFastAttack(bool knightIsAwake)
    {
        if (knightIsAwake == true)
        {
            return false;
        } 
        else 
        {
            return true;
        }
    }

    public static bool CanSpy(bool knightIsAwake, bool archerIsAwake, bool prisonerIsAwake)
    {    
       if ((knightIsAwake == true) || (archerIsAwake == true) || (prisonerIsAwake == true)) 
        {
           return true;
        }
           else 
           {
               return false;
           }
    }

    public static bool CanSignalPrisoner(bool archerIsAwake, bool prisonerIsAwake)
    {
        if ((archerIsAwake == false) && (prisonerIsAwake == true)) 
        {
           return true;
        }
           else 
           {
               return false;
           }
    }

    public static bool CanFreePrisoner(bool knightIsAwake, bool archerIsAwake, bool prisonerIsAwake, bool petDogIsPresent)
    {
        if ((archerIsAwake == false) && (prisonerIsAwake == true) && (petDogIsPresent == true))
        {
           return true;
        }
        
        else if ((archerIsAwake == false) && (prisonerIsAwake == true) && (knightIsAwake == false))
           {
               return true;
           }

        else if ((archerIsAwake == false) && (prisonerIsAwake == false) && (petDogIsPresent == true))
           {
               return true;
           }

        else 
        {
            return false;
        }
    }
}
