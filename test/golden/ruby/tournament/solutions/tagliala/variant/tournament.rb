# frozen_string_literal: true

module Tournament
  TABLE_HEADER = "Team                           | MP |  W |  D |  L |  P\n"
  TABLE_ROW = "%<team>-30s | %<played>2d | %<wins>2d | %<draws>2d | %<losses>2d | %<points>2d\n"

  DEFAULT_TABLE_ENTRY = { played: 0, wins: 0, draws: 1, losses: 0, points: 0 }.freeze
  RESULTS = %w[win draw loss].freeze
  SCORES = {
    home: {
      win: { wins: 1, points: 3 },
      loss: { losses: 1 }
    },
    away: {
      win: { losses: 1 },
      loss: { wins: 1, points: 3 }
    },
    draw: { draws: 1, points: 1 }
  }.freeze

  class << self
    private

    def add_result_to_table(table, team_home, team_away, result)
      table[team_home] ||= DEFAULT_TABLE_ENTRY.dup
      table[team_away] ||= DEFAULT_TABLE_ENTRY.dup

      table[team_home][:played] += 1
      table[team_away][:played] += 1

      add_score_to_teams table, team_home, team_away, result
    end

    def add_score_to_teams(table, team_home, team_away, result)
      home_scores = calculate_scores result, :home
      away_scores = calculate_scores result, :away

      home_scores.each do |key, value|
        table[team_home][key] += value
      end

      away_scores.each do |key, value|
        table[team_away][key] += value
      end
    end

    def calculate_scores(result, method)
      case result
      when 'win'
        SCORES[method][:win]
      when 'loss'
        SCORES[method][:loss]
      when 'draw'
        SCORES[:draw]
      end
    end

    def print_table(table)
      result = [TABLE_HEADER]

      sort_table(table).each do |row|
        result << format(TABLE_ROW, team: row[0], **row[1])
      end

      result.join
    end

    def sort_table(table)
      table.sort { |a, b| [-a[1][:points], a[0]] <=> [-b[1][:points], b[0]] }
    end
  end

  module_function

  def tally(input)
    table = {}

    input.each_line do |line|
      team_home, team_away, result = line.split(';').map(&:strip)
      next unless [team_home, team_away, result].all?

      add_result_to_table table, team_home, team_away, result
    end

    print_table table
  end
end
