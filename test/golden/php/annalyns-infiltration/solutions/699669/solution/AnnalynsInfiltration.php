<?php

class AnnalynsInfiltration
{
    public function canFastAttack($is_knight_awake)
    {
        if(!$is_knight_awake) {
            return true;
        } else {
            return false;
        }
        throw new \BadFunctionCallException("Implement the function");
    }

    public function canSpy(
        $is_knight_awake,
        $is_archer_awake,
        $is_prisoner_awake
    ) {
        if($is_knight_awake || $is_archer_awake || $is_prisoner_awake ) {
            return true;
        } else {
            return false;
        }
        throw new \BadFunctionCallException("Implement the function");
    }

    public function canSignal(
        $is_archer_awake,
        $is_prisoner_awake
    ) {
        if(!$is_archer_awake && !$is_prisoner_awake) {
            return false;
        } else if (!$is_archer_awake && $is_prisoner_awake) {
            return true;
        } else if ($is_archer_awake && !$is_prisoner_awake) {
            return false;
        } else if ($is_archer_awake && $is_prisoner_awake){
            return false;
        }
        throw new \BadFunctionCallException("Implement the function");
    }

    public function canLiberate(
        $is_knight_awake,
        $is_archer_awake,
        $is_prisoner_awake,
        $is_dog_present
    ) { if ($is_knight_awake && $is_archer_awake && $is_prisoner_awake) {
            if ($is_dog_present) {
                return false;
            } else if (!$is_dog_present) {
                return false;
            }
    } else if(!$is_knight_awake && !$is_archer_awake && !$is_prisoner_awake && !$is_dog_present) {
            return false; 
        } else if (!$is_knight_awake && !$is_archer_awake && ($is_prisoner_awake || $is_dog_present)) {
            return true;
        } else if (!$is_knight_awake  && !$is_prisoner_awake) {
            if(!$is_dog_present || $is_archer_awake) {
                return false;
            }
        } else if ($is_archer_awake && $is_prisoner_awake) {
            if ((!$is_knight_awake && $is_dog_present) || (!$is_knight_awake && !$is_dog_present)) {
                return false;
            }
        } else if (!$is_archer_awake && !$is_prisoner_awake) {
            if ($is_knight_awake && !$is_dog_present) {
                return false;
                } else if ($is_knight_awake && $is_dog_present) {
                        return true;
                  }
        } else if ($is_knight_awake && $is_prisoner_awake) {
            if (!$is_archer_awake && !$is_dog_present) {
                return false;
            } else if (!$is_archer_awake && $is_dog_present) {
                return true;
            }
        } else if ($is_knight_awake && $is_archer_awake) {
            if (!$is_prisoner_awake && !$is_dog_present) {
                return false;
            } else if (!$is_prisoner_awake && $is_dog_present) {
                return false;
            } else {
                return false;
            } 
        }     
        throw new \BadFunctionCallException("Implement the function");
    }
}

/*            else if ($is_prisoner_awake && !$is_dog_present) {
                return false;
            } else if ($is_prisoner_awake && $is_dog_present) {
                return false;
            }
*/
