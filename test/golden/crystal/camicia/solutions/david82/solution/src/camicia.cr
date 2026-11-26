require "deque"

class Camicia
  def initialize(player_a : Array(String), player_b : Array(String))
    @init_a = player_a.dup
    @init_b = player_b.dup
    @a = Deque(String).new(player_a)
    @b = Deque(String).new(player_b)
    @pile = [] of String
    @moves = 0
    @tricks = 0
    @total = player_a.size + player_b.size
    @leader = :a
  end

  def simulate_game
    @a = Deque(String).new(@init_a)
    @b = Deque(String).new(@init_b)
    @pile.clear
    @moves = 0
    @tricks = 0
    @leader = :a

    seen = Set(String).new

    loop do
      if @pile.empty? && (@a.size == @total || @b.size == @total)
        return {status: "finished", moves: @moves, tricks: @tricks}
      end

      if @pile.empty?
        key = state_key
        if seen.includes?(key)
          return {status: "loop", moves: @moves, tricks: @tricks}
        end
        seen << key
      end

      play_trick
    end
  end

  private def state_key : String
    String.build(@a.size + @b.size + 2) do |io|
      append_normalized(io, @a)
      io << '|'
      append_normalized(io, @b)
      io << '|' << (@leader == :a ? 'a' : 'b')
    end
  end

  private def append_normalized(io : String::Builder, deck : Deque(String))
    deck.each do |c|
      io << case c
      when "J" then 'J'
      when "Q" then 'Q'
      when "K" then 'K'
      when "A" then 'A'
      else       'N'
      end
    end
  end

  private def payment_value(card : String) : Int32?
    case card
    when "J" then 1
    when "Q" then 2
    when "K" then 3
    when "A" then 4
    else         nil
    end
  end

  private def other(p : Symbol) : Symbol
    p == :a ? :b : :a
  end

  private def pop_card!(p : Symbol) : String
    p == :a ? @a.shift : @b.shift
  end

  private def deck_empty?(p : Symbol) : Bool
    p == :a ? @a.empty? : @b.empty?
  end

  private def play_trick
    player = @leader

    loop do
      if deck_empty?(player)
        collect_trick(other(player))
        return
      end

      card = pop_card!(player)
      @pile << card
      @moves += 1

      if pv = payment_value(card)
        resolve_penalty(face_owner: player, payer: other(player), owe: pv)
        return
      end

      player = other(player)
    end
  end

  private def resolve_penalty(face_owner : Symbol, payer : Symbol, owe : Int32)
    while owe > 0
      if deck_empty?(payer)
        collect_trick(other(payer))
        return
      end

      card = pop_card!(payer)
      @pile << card
      @moves += 1

      if pv = payment_value(card)
        resolve_penalty(face_owner: payer, payer: other(payer), owe: pv)
        return
      end

      owe -= 1
    end

    collect_trick(face_owner)
  end

  private def collect_trick(winner : Symbol)
    @tricks += 1
    if winner == :a
      @a.concat(@pile)
    else
      @b.concat(@pile)
    end
    @pile.clear
    @leader = winner
  end
end
