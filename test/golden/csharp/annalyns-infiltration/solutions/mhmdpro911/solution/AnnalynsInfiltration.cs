using System;

static class QuestLogic
{
    public static bool CanFastAttack(bool knightIsAwake)
    {
        return !knightIsAwake;
    }

    public static bool CanSpy(bool knightIsAwake, bool archerIsAwake, bool prisonerIsAwake)
    {
        return knightIsAwake || archerIsAwake || prisonerIsAwake;
    }

    public static bool CanSignalPrisoner(bool archerIsAwake, bool prisonerIsAwake)
    {
        if(!archerIsAwake)
            return prisonerIsAwake;
        return false;
    }

    public static bool CanFreePrisoner(bool knightIsAwake, bool archerIsAwake, bool prisonerIsAwake, bool petDogIsPresent)
    {
        
        if(knightIsAwake == false && archerIsAwake == false && prisonerIsAwake == true)
            return true;
        
        if(knightIsAwake == false && archerIsAwake == false && petDogIsPresent == true)
            return true;
        if(archerIsAwake == false && prisonerIsAwake == true && petDogIsPresent == true)
            return true;
        if(archerIsAwake == false && knightIsAwake == true && petDogIsPresent == true)
            return true;
        return false;
    }
}
