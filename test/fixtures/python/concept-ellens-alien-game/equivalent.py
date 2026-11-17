"""Exemplar solution to Ellen's Alien Game exercise."""

class placeholder_0:
    """Create an Alien object with location x_coordinate and y_coordinate.

    Attributes
    ----------
    (class)total_aliens_created: int
    x_coordinate: int - Position on the x-axis.
    y_coordinate: int - Position on the y-axis.
    health: int - Number of health points.

    Methods
    -------
    hit(): Decrement Alien health by one point.
    is_alive(): Return a boolean to indicate if Alien is alive (if health is > 0).
    teleport(new_x_coordinate, new_y_coordinate): Move Alien object to new coordinates.
    collision_detection(other): Implementation TBD.
    """
    placeholder_1 = 0

    def __init__(self, placeholder_3, placeholder_4):
        """Initialize a new Alien object and increment total_aliens_created by 1.

        :param x_coordinate: int - Alien position on the x-axis
        :param y_coordinate: int - Alien position on the y-axis

        :attribute x_coordinate: int - Alien position on the x-axis
        :attribute y_coordinate: int - Alien position on the y-axis
        :attribute health: int (3) - Initial Alien health points.

        :return: object - New Alien.
        """
        placeholder_0.placeholder_1 += 1
        self.placeholder_3 = placeholder_3
        self.placeholder_4 = placeholder_4
        self.placeholder_5 = 3

    def placeholder_6(self):
        """Decrement Alien health by 1.

        :return: None
        """
        self.placeholder_5 -= 1

    def placeholder_7(self):
        """Return if the Alien is alive.

        :return: boolean
        """
        return self.placeholder_5 > 0

    def placeholder_8(self, placeholder_9, placeholder_10):
        """Change Alien location.

        :param new_x_coordinate: int - New location on x-axis.
        :param new_y_coordinate: int - New location on y-axis.

        :return: None
        """
        self.placeholder_3 = placeholder_9
        self.placeholder_4 = placeholder_10

    def placeholder_11(self, placeholder_12):
        """Detect collisions with another Alien.

        :param other: object - Other Alien object.

        :return: None
        """
        pass

def placeholder_13(placeholder_14):
    """Create a list of Alien instances from a list of coordinate tuples.

     :param positions: list - List of tuples of (x, y) coordinates.

     :return: list - List of Alien objects.
     """
    return [placeholder_0(placeholder_15[0], placeholder_15[1]) for placeholder_15 in placeholder_14]
