using System;

public class Player
{
    private Random _rnd = new();
    public int RollDie() => this._rnd.Next(1, 19);

    public double GenerateSpellStrength() => this._rnd.NextDouble();
}
