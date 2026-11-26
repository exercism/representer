class Clock
    constructor: (hours, minutes = 0) ->
        minutes = (hours * 60 + minutes) % 1440
        minutes += 1440 if minutes < 0
        @hours = minutes // 60
        @minutes = minutes % 60

    plus: (minutes) ->
        new Clock(@hours, @minutes - minutes)

    minus: (minutes) -> @plus(-minutes)

    equals: (clock) ->
        @hours == clock.hours and @minutes == clock.minutes

    toString: ->
        "#{@hours.toString().padStart(2, '0')}:#{@minutes.toString().padStart(2, '0')}"

module.exports = Clock
