pub struct Player {
    pub health: u32,
    pub mana: Option<u32>,
    pub level: u32,

    
}

impl Player {
    const MANA_UNLOCK_LVL : u32 = 10;
    const HP_ON_REVIVE : u32 = 100;
    const MANA_ON_REVIVE : u32 = 100;

    pub fn revive(&self) -> Option<Player> {
        if self.health > 0 {None}
        else {
            Some(Player{
                health : Player::HP_ON_REVIVE,
                mana : { 
                    if self.level >= Player::MANA_UNLOCK_LVL {
                         Some(Player::MANA_ON_REVIVE) 
                    }
                    else { None } 
                },
                level : self.level,
            })
        }
    }

    pub fn cast_spell(&mut self, mana_cost: u32) -> u32 {
        match self.mana {
            Some(amount) => {
                if amount <= mana_cost {0}
                else {
                    self.mana = Some(amount - mana_cost); mana_cost*2
                }
            },
            None => { self.take_flat_damage(mana_cost); 0 }
        }
    }

    fn take_flat_damage(&mut self, damage_taken: u32) {
        self.health = {
            if damage_taken < self.health { self.health - damage_taken }
            else { 0 }
        }
    }
}
