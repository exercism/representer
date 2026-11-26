public enum Direction
{
	North = 90,
	East = 0,
	South = 270,
	West = 180
}

public class RobotSimulator
{
	private int _x;
	private int _y;
	private int _direction;
	public RobotSimulator(Direction direction, int x, int y)
	{
		_x = x;
		_y = y;
		_direction = (int)direction;
	}

	public Direction Direction
	{
		get
		{
			if (_direction < 0)
			{
				while (_direction < 0)
				{
					_direction += 360;
				}
			}
			else
			{
				while (_direction >= 360)
				{
					_direction -= 360;
				}
			}			
			return (Direction)_direction;
		}
	}
	public int X
	{
		get{return _x;}
	}

	public int Y
	{
		get { return _y; }
	}

	public void Move(string instructions)
	{
		foreach(char c in instructions)
		{
            Direction fu = Direction;
			if(c == 'A')
			{
				if(_direction==90|| _direction == 270)
				{
					_y = _direction == 270 ? _y - 1 : _y + 1;
				}
				else
				{
					_x = _direction == 180 ? _x - 1 : _x + 1;
				}
			}
			if (c == 'L') _direction += 90;
			if (c == 'R') _direction -= 90;
            Console.WriteLine($"_x-{_x}");
            Console.WriteLine($"_y-{_y}");
            Console.WriteLine($"_direction-{_direction}");
		}
	}
    
}