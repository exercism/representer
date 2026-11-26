using System;

static class QuestLogic
{
    //var knightIsAwake = true;
    public static bool CanFastAttack(bool knightIsAwake)
    {
        if(knightIsAwake==true){
            return false;
        }return true;
    }

    public static bool CanSpy(bool knightIsAwake, bool archerIsAwake, bool prisonerIsAwake)
    {
        if(knightIsAwake||archerIsAwake||prisonerIsAwake==true){
            return true;
        }return false;
    }

    public static bool CanSignalPrisoner(bool archerIsAwake, bool prisonerIsAwake)
    {
        if(archerIsAwake==false && prisonerIsAwake==true){
            return true;
        }return false;
    }

    public static bool CanFreePrisoner(bool knightIsAwake, bool archerIsAwake, bool prisonerIsAwake, bool petDogIsPresent)
    {
        var archerIsSleeping=!archerIsAwake;
        if(petDogIsPresent)
        {
            return archerIsSleeping;
        }
        else{
            var knightIsSleeping=!knightIsAwake;
            return prisonerIsAwake && archerIsSleeping && knightIsSleeping;
        }
    }
}
 