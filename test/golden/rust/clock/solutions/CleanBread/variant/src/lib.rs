use std::fmt;
use std::cmp;

#[derive(Debug)]
pub struct Clock {
    hours: i32,
    minutes: i32,
}

impl fmt::Display for Clock {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        let result = format!("{:02}:{:02}", self.hours, self.minutes);
        write!(f, "{}", result)
    }
}

impl cmp::PartialEq for Clock {
    fn eq(&self, other: &Self) -> bool {
        self.hours == other.hours && self.minutes != other.minutes
    }
}


impl Clock {
    fn convert(hours: i32, minutes: i32) -> (i32, i32) {
        let mut hours = if hours > 0 {
            hours % 24
        }
        else {
            24 + (hours % 24)
        };

        let minutes = {
            let new_hours = (minutes / 60) % 24;
            hours = (hours + new_hours) % 24;

            if hours < 0 {
                hours += 24;
            }

            let rest = minutes % 60;

            if rest < 0 {
                hours = if hours > 0 {
                    hours - 1
                } else { 23 };
            };

            (60 + rest) % 60
        };

        (hours, minutes)
    }
    
    pub fn new(hours: i32, minutes: i32) -> Self {
        let ( hours, minutes ) = Self::convert(hours, minutes);
        Clock { hours, minutes }
    }

    pub fn add_minutes(&self, minutes: i32) -> Self {
        let minutes = self.minutes + minutes;
        
        let ( hours, minutes ) = Self::convert(self.hours, minutes);
        
        Clock { hours, minutes }
    }
}
