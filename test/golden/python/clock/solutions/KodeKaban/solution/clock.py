class Clock:
    def __init__(self, hour, minute):
        self.current_time = (hour, minute)

    
    def __repr__(self):
        return "Clock" + str(self.current_time)

    
    def __str__(self):
        #convert time to minutes 
        self.total_time = (self.current_time[0] * 60) + self.current_time[1]
        self.string_time = self.processor(self.total_time)
        return self.formatter(self.string_time)

        
    def __eq__(self, other):
        #get time from other clock
        other_clock = other.current_time
        #convert time from both clocks into hours and minutes
        self.main_clock_compare = self.processor((self.current_time[0] * 60) + self.current_time[1])
        self.other_clock_compare = self.processor((other_clock[0] * 60) + other_clock[1])
        #format both processed times as strings
        self.main_clock_formatted = self.formatter(self.main_clock_compare)
        self.other_clock_formatted = self.formatter(self.other_clock_compare)
        #compare strings
        if self.main_clock_formatted == self.other_clock_formatted:
            return True

    
    def __add__(self, minutes):
        #convert time to minutes, add, then send to processor and returned formatted versions
        self.minutes_to_add = (self.current_time[0] * 60) + self.current_time[1] + minutes
        self.added_time = self.processor(self.minutes_to_add)
        return self.formatter(self.added_time)
        

    def __sub__(self, minutes):
        #convert time to minutes, subtract, then send to processor and returned formatted versions
        self.minutes_to_subtract = (self.current_time[0] * 60) + self.current_time[1] - minutes
        self.subtracted_time = self.processor(self.minutes_to_subtract)
        return self.formatter(self.subtracted_time)
        

    def processor(self, minutes):
        #get hours as fully divisible portion and minutes as remainder
        processed_hours = minutes // 60
        processed_minutes = minutes % 60
        #roll back clock if value is negative, roll forwards if over 24
        if processed_hours < 0 and processed_hours > -24:
            processed_hours = 24 - abs(processed_hours)
        elif processed_hours < -24:
            processed_hours = 24 - (abs(processed_hours) % 24)
        elif processed_hours > 24:
            processed_hours = processed_hours % 24
        return [abs(processed_hours), abs(processed_minutes)]

    
    def formatter(self, time):
        self.formatted_time = []
        self.operation_time = time
        #add zero to front of single digit number, turn 24 to 00, else write as is
        if self.operation_time[0] < 10:
            self.formatted_time.append("0" + str(self.operation_time[0]))
        elif self.operation_time[0] == 24:
            self.formatted_time.append("00")
        else:
            self.formatted_time.append(str(self.operation_time[0]))
        #make 0 into 00, add zero to front of single digit number, else write as is
        if self.operation_time[1] == 0:
            self.formatted_time.append("00")
        elif self.operation_time[1] < 10:
            self.formatted_time.append("0" + str(self.operation_time[1]))
        else:
            self.formatted_time.append(str(self.operation_time[1]))
        #return formatted result
        return self.formatted_time[0] + ":" + self.formatted_time[1]