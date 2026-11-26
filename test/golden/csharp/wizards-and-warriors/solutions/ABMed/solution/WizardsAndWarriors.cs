abstract class Character
{
    string _characterType;
    protected Character(string characterType)
    {
        //throw new NotImplementedException("Please implement the Character() constructor");
        this._characterType = characterType;
    }

    public abstract int DamagePoints(Character target);

    public virtual bool Vulnerable()
    {
        //throw new NotImplementedException("Please implement the Character.Vulnerable() method");
        return false;
    }

    public override string ToString()
    {
        //throw new NotImplementedException("Please implement the Character.ToString() method");
        return $"Character is a {_characterType}";
    }
}

class Warrior : Character
{
    public Warrior() : base("Warrior")
    {
    }

    public override int DamagePoints(Character target) => target.Vulnerable() ? 10 : 6;
    //{
    //    //throw new NotImplementedException("Please implement the Warrior.DamagePoints() method");
    //}
}

class Wizard : Character
{
    bool spellPrepared = false; 
    public Wizard() : base("Wizard")
    {
    }

    public override int DamagePoints(Character target) => spellPrepared ? 12 : 3;
    //{
    //    throw new NotImplementedException("Please implement the Wizard.DamagePoints() method");
    //}

    public void PrepareSpell()
    {
        //throw new NotImplementedException("Please implement the Wizard.PrepareSpell() method");
        spellPrepared = true;
    }

    public override bool Vulnerable() => !spellPrepared;
}
