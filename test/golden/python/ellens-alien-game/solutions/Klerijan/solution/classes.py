"""Solution to Ellen's Alien Game exercise."""


class Alien:
    """Create an Alien object with location x_coordinate and y_coordinate.

    Attributes
    ----------
    (class)total_aliens_created: int
    x_coordinate: int - Position on the x-axis.
    y_coordinate: int - Position on the y-axis.
    health: int - Amount of health points.

    Methods
    -------
    hit(): Decrement Alien health by one point.
    is_alive(): Return a boolean for if Alien is alive (if health is > 0).
    teleport(new_x_coordinate, new_y_coordinate): Move Alien object to new coordinates.
    collision_detection(other): Implementation TBD.
    """

    health=3
    total_aliens_created=0

    def __init__(self, c1,c2):
        self.x_coordinate=c1
        self.y_coordinate=c2
        Alien.total_aliens_created+=1
    def hit(self):
        self.health = max(0, self.health - 1)
    def is_alive(self):
        if self.health>0:
            return True
        else:
            return False
    def teleport(self,c1,c2):
        self.x_coordinate=c1
        self.y_coordinate=c2
    def collision_detection(self,other_object):
        pass

        
    
def new_aliens_collection(alien_start_positions):
    aliens=[]
    for pos in alien_start_positions:
        aliens.append(Alien(pos[0],pos[1]))
    return aliens



