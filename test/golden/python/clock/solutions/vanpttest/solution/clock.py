class Clock:
    def calculate(self, hour, minute):
        if minute >= 60:
            plusHour = int(minute / 60)
            minute = minute - plusHour * 60
            hour += plusHour

        if minute < 0:
            minusHour = int(minute / 60)
            minute = minute - minusHour * 60

            if minute != 0:
                minute = 60 + minute

            hour += minusHour

            if minute != 0:
                hour -= 1

        if hour > 24:
            hour = hour - int(hour / 24) * 24

        if hour < 0:
            hour = hour - int(hour / 24) * 24
            hour = 24 + hour

        if hour == 24:
            hour = 0

        self.hour = hour
        self.minute = minute

    def __init__(self, hour, minute):
        self.calculate(hour, minute)

    def __repr__(self):
        return f"Clock({self.hour}, {self.minute})"

    def __str__(self):
        return f"{str(self.hour).zfill(2)}:{str(self.minute).zfill(2)}"

    def __eq__(self, other):
        return self.hour == other.hour and self.minute == other.minute

    def __add__(self, minutes):
        self.minute += minutes
        self.calculate(self.hour, self.minute)
        return self.__str__()

    def __sub__(self, minutes):
        self.minute -= minutes
        self.calculate(self.hour, self.minute)
        return self.__str__()
