class Clock:
    def __init__(self, hour, minute):
        self.hour = (hour + minute // 60) % 24
        self.minute = minute % 60

    def __repr__(self):
        return f"Clock({self.hour}, {self.minute})"

    def __str__(self):
        new_min = self.double_digit(self.minute)
        new_hr = self.double_digit(self.hour)
        return f"{new_hr}:{new_min}"
        
    def __eq__(self, other):
        return (self.hour == other.hour and self.minute == other.minute)

    def __add__(self, minutes):
        total_min = self.hour*60 + self.minute
        new_min = total_min + minutes
        while new_min > 1440:
            new_min -= 1440

        self.hour = round((new_min // 60) % 24)
        self.minute = new_min % 60
        
        return self 

    def __sub__(self, minutes):
        total_min = self.hour*60 + self.minute
        new_min = total_min - minutes
        while new_min < 0:
            new_min += 1440

        self.hour = round((new_min // 60) % 24)
        self.minute = new_min % 60
        
        return self 

    def double_digit(self, unit):
        if unit <= 9:
            return f"0{unit}"
        else:
            return str(unit)
        
