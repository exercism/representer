using System;

abstract class Character
{
    private readonly string characterType;
    protected Character(string characterType)
    {
        this.characterType = characterType;
    }

    public abstract int DamagePoints(Character target);

    public virtual bool Vulnerable()
        => false;

    public override string ToString()
        => $"Character is a {this.characterType}";
}

class Warrior : Character
{
    public Warrior() : base("Warrior")
    {
    }

    public override int DamagePoints(Character target)
        => target.Vulnerable()? 10 : 6;

    public override string ToString() => "Character is a Warrior";
}

class Wizard : Character
{
    private bool isSpellPrepared = false;
    public Wizard() : base("Wizard")
    {
    }

    public override int DamagePoints(Character target)
    {
        int damage = isSpellPrepared ? 12: 3;
        isSpellPrepared = false;
        return damage;
    }

    public override bool Vulnerable() => !isSpellPrepared;

    public void PrepareSpell()
        => this.isSpellPrepared = true;

	public override string ToString() => "Character is a Wizard";
}
