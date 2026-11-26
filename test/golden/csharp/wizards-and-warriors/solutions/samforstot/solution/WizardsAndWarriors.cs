using System;

abstract class Character
{
    private string characterType; 

    protected Character(string characterType)
    {
        this.characterType = characterType; 
        //throw new NotImplementedException("Please implement the Character() constructor");
    }

    public abstract int DamagePoints(Character target);

    public virtual bool Vulnerable()
    {
        return false; 
        //throw new NotImplementedException("Please implement the Character.Vulnerable() method");
    }

    public override string ToString()
    {
        return $"Character is a {characterType}";
        //throw new NotImplementedException("Please implement the Character.ToString() method");
    }
}

class Warrior : Character
{
    public Warrior() : base("Warrior")
    {
    }

    public override int DamagePoints(Character target)
    {
        if(target.Vulnerable()){
            return 10;
        }
        return 6;
        //throw new NotImplementedException("Please implement the Warrior.DamagePoints() method");
    }
}

class Wizard : Character
{
    private bool isPrepared = false; 
    public Wizard() : base("Wizard")
    {
    }

    public override int DamagePoints(Character target)
    {
        if(isPrepared){
            return 12;
        }
        return 3; 
        //throw new NotImplementedException("Please implement the Wizard.DamagePoints() method");
    }

    public override bool Vulnerable()
    {
        return !isPrepared; 
    }
    public void PrepareSpell()
    {
        isPrepared = true; 
        //throw new NotImplementedException("Please implement the Wizard.PrepareSpell() method");
    }
}
