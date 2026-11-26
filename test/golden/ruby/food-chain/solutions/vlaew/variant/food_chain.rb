module FoodChain
  VERSION = 2

  class << self
    def song
      lines = []
      generate_creatures.each_with_object([]) do |creature, creatures|
        creatures.unshift(creature)
        lines += creatures_lines(creatures)
        lines << ""
      end
      lines.join("\n")
    end

    private

    def creatures_lines(creatures)
      lines = []
      creatures.each_with_index.each do |creature, i|
        lines += creature_lines(
          creature: creature,
          next_creature: creatures[i - 1],
          first: i == 0,
          last: i == creatures.size - 1
        )
        break if creature.stopper
      end
      lines
    end

    def creature_lines(creature:, next_creature:, first:, last:)
      lines = []
      lines << introduction(creature) if first
      lines << creature.description if first || last
      lines << reason(creature, next_creature) if next_creature && !creature.stopper
      lines
    end

    def introduction(creature)
      "I know an old lady who swallowed a #{creature.name}."
    end

    def reason(creature, next_creature)
      next_creature_mention = [next_creature.name, next_creature.mention_text].compact.join(' ')
      "She swallowed the #{creature.name} to catch the #{next_creature_mention}."
    end

    def generate_creatures
      [
        Creature.new(
          name: 'fly',
          description: "I don't know why she swallowed the fly. Perhaps she'll die.",
        ),
        Creature.new(
          name: 'spider',
          description: "It wriggled and jiggled and tickled inside her.",
          mention_text: "that wriggled and jiggled and tickled inside her"
        ),
        Creature.new(
          name: 'bird',
          description: "How absurd to swallow a bird!",
          mention_next_creature: true
        ),
        Creature.new(
          name: 'cat',
          description: "Imagine that, to swallow a cat!"
        ),
        Creature.new(
          name: 'dog',
          description: "What a hog, to swallow a dog!"
        ),
        Creature.new(
          name: 'goat',
          description: "Just opened her throat and swallowed a goat!"
        ),
        Creature.new(
          name: 'cow',
          description: "I don't know how she swallowed a cow!"
        ),
        Creature.new(
          name: 'horse',
          description: "She's dead, of course!",
          stopper: true
        )
      ]
    end
  end

  class Creature
    attr_reader :name, :description, :mention_next_creature, :stopper, :mention_text

    def initialize(name:, description:, mention_next_creature: false, stopper: false, mention_text: nil)
      @name = name
      @description = description
      @mention_next_creature = mention_next_creature
      @stopper = stopper
      @mention_text = mention_text
    end
  end
end