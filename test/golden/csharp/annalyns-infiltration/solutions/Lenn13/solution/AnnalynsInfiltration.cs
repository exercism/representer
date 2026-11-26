using System;

static class QuestLogic
{
    public static bool CanFastAttack(bool knightIsAwake)
    {
        if(knightIsAwake == true)
            return false;
        else
            return true;
    }

    public static bool CanSpy(bool knightIsAwake, bool archerIsAwake, bool prisonerIsAwake)
    {
        if(knightIsAwake == false && archerIsAwake == false && prisonerIsAwake == false)
            return false;
        else
            return true;
    }

    public static bool CanSignalPrisoner(bool archerIsAwake, bool prisonerIsAwake)
    {
        if(prisonerIsAwake == true && archerIsAwake == false)
            return true;
        else
            return false;
    }

    public static bool CanFreePrisoner(bool knightIsAwake, bool archerIsAwake, bool prisonerIsAwake, bool petDogIsPresent)
    {
         if(archerIsAwake == false && petDogIsPresent == true)
             return true;
        else if(prisonerIsAwake == true && knightIsAwake == false && archerIsAwake == false)
            return true;
        else
            return false;
    }
}
