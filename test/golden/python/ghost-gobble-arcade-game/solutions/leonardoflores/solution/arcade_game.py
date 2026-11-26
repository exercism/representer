"""Functions for implementing the rules of the classic arcade game Pac-Man."""


def eat_ghost(power_pellet_active, touching_ghost):
    return True if power_pellet_active and touching_ghost else False


def score(touching_power_pellet, touching_dot):
    return True if touching_power_pellet or touching_dot else False

def lose(power_pellet_active, touching_ghost):
    return True if touching_ghost and power_pellet_active == False else False


def win(has_eaten_all_dots, power_pellet_active, touching_ghost):
    if touching_ghost:
        if power_pellet_active == False:
            return False
        else:
            if has_eaten_all_dots:
                return True
            else:
                return False
    else:
        if has_eaten_all_dots:
            return True
        else:
            return False