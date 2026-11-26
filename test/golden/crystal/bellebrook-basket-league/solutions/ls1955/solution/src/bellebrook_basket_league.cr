module TicketingReservation
  getter :tickets_available

  def order_ticket?
    return false if tickets_available < 100

    @tickets_available -= 1
    true
  end

  def order_message(name)
    ticket_number = tickets_available

    if order_ticket?
      "#{name}, your purchase was successful, your ticket number is ##{ticket_number}, and the game is played at the #{stadium} stadium."
    else
      "#{name}, your purchase was unsuccessful, there are not enough tickets available."
    end
  end
end

class TicketSystem
  include TicketingReservation

  getter :stadium

  def initialize(@tickets_available : Int32, @stadium : String)
  end
end