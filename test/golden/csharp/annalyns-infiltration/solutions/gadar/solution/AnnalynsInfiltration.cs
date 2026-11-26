using System;

static class QuestLogic
{
    public static bool CanFastAttack(bool knightIsAwake)
    {
        return !knightIsAwake;
    } //public static bool CanFastAttack(bool knightIsAwake)

    public static bool CanSpy(bool knightIsAwake, bool archerIsAwake, bool prisonerIsAwake)
    {
        bool output = knightIsAwake || archerIsAwake || prisonerIsAwake;

        return output;
    } //public static bool CanSpy(bool knightIsAwake, bool archerIsAwake, bool prisonerIsAwake)

    public static bool CanSignalPrisoner(bool archerIsAwake, bool prisonerIsAwake)
    {
        bool output = prisonerIsAwake && !archerIsAwake;

        return output;
    } //public static bool CanSignalPrisoner(bool archerIsAwake, bool prisonerIsAwake)

    public static bool CanFreePrisoner(bool knightIsAwake, bool archerIsAwake, bool prisonerIsAwake,
        bool petDogIsPresent)
    {
        bool output = (petDogIsPresent && !archerIsAwake) || 
                      (!petDogIsPresent && prisonerIsAwake && (!archerIsAwake && !knightIsAwake)); 

        return output;
    } //public static bool CanFreePrisoner(bool knightIsAwake, bool archerIsAwake, bool prisonerIsAwake,
}
