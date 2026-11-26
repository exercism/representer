import Foundation

struct Clock: Equatable {
    private let MINUTES_IN_HOUR = 1440
    private var minutes: Int
    
    init(hours: Int, minutes: Int) {
        self.minutes = (minutes + hours * 60) % MINUTES_IN_HOUR
        
        if self.minutes < 0 {
            self.minutes = MINUTES_IN_HOUR + (self.minutes % MINUTES_IN_HOUR)
        }
    }
    
    var description: String {
        return "\(String(format: "%02d", (self.minutes / 60) % 24)):\(String(format: "%02d", self.minutes % 60))"
    }
    
    func add(minutes: Int) -> Self {
        return Clock(hours: 0, minutes: self.minutes + minutes)
    }
    
    func subtract(minutes: Int) -> Self {
        return Clock(hours: 0, minutes: self.minutes - minutes)
    }
}
