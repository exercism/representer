using System;

abstract class Character
{
    protected string CharType { get; set; }
    
    protected Character(string characterType)
    {
        CharType = characterType;
    }

    public abstract int DamagePoints(Character target);

    public virtual bool Vulnerable()
    {
        return false;
    }

    public override string ToString()
    {
        return $"Character is a {CharType}";
    }
}

class Warrior : Character
{
    public Warrior() : base("Warrior")
    {
    }

    public override int DamagePoints(Character target)
    {
        return target.Vulnerable() ? 10 : 6;
    }
}

class Wizard : Character
{
    private bool IsVulnerable { get; set; } = true;

    public Wizard() : base("Wizard")
    {
    }

    public override int DamagePoints(Character target)
    {
        return IsVulnerable ? 3 : 12;
    }

    public override bool Vulnerable()
    {
        return IsVulnerable;
    }

    public void PrepareSpell()
    {
        IsVulnerable = false;
    }
}
