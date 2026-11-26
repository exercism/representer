def update_standings(standings, team_a, team_b, result):
    if result == 'win':
        standings = update_team_stats(standings, team_a, 'win')
        standings = update_team_stats(standings, team_b, 'loss')
    elif result == 'loss':
        standings = update_team_stats(standings, team_a, 'loss')
        standings = update_team_stats(standings, team_b, 'win')
    else:
        standings = update_team_stats(standings, team_a, 'draw')
        standings = update_team_stats(standings, team_b, 'draw')
    return standings

def update_team_stats(standings, team, result):
    matches_played, wins, draws, losses, points = standings[team]
    if result == 'win':
        standings[team] = (matches_played+1, wins+1, draws, losses, points+3)
    elif result == 'loss':
        standings[team] = (matches_played-1, wins, draws, losses+1, points)
    else:
        standings[team] = (matches_played+1, wins, draws+1, losses, points+1)
    return standings

def initialize_teams(results):
    teams = {}
    for result in results:
        team_a, team_b, _ = result.split(';')
        teams.setdefault(team_a, (0, 0, 0, 0, 0))
        teams.setdefault(team_b, (0, 0, 0, 0, 0))
    return teams

def process_results(results):
    standings = initialize_teams(results)
    for result in results:
        team_a, team_b, match_result = result.split(';')
        standings = update_standings(standings, team_a, team_b, match_result)
    return standings

def tally(results):
    standings = process_results(results)
    leaderboard = []
    if len(standings) > 0:
        max_points = max([points for (mp, wins, draws, losses, points) in standings.values()])
    for team, stats in standings.items():
        matches_played, wins, draws, losses, points = stats
        team_line = f'{max_points-(points+1)},' + f'{team: <30} |  {matches_played} |  {wins} |  {draws} |  {losses} | {points:>2}'
        leaderboard.append(team_line)
    leaderboard = sorted(leaderboard, reverse=False)
    
    formatted_leaderboard = []
    header = f'{"Team": <30} | {"MP"} |  {"W"} |  {"D"} |  {"L"} | {"P": >2}'
    formatted_leaderboard.append(header)
    for entry in leaderboard:
        _, row = entry.split(',')
        formatted_leaderboard.append(row)
    
    return formatted_leaderboard
    
