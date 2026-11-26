Tournament :: {}.{
	tally : Str -> Try(Str, [InvalidInput(Str), InvalidMatchResult(Str)])
    tally = |table| {
        if table.is_empty()
            return Ok(header)
        
        matches = parse_input(table)?

        matches
        |> compute_tally()
        |> order_tally()
        |> display_tally()
        |> Ok()
    }
}

MatchResult : [Win, Loss, Draw]
Match : {
    team1 : Str,
    team2 : Str,
    result : MatchResult,
}

TeamTally : {
    matches_played : U8,
    wins : U8,
    losses : U8,
    draws : U8,
    points : U8,
}
CompetitionTally : Dict(Str, TeamTally)

header = "Team                           | MP |  W |  D |  L |  P"

parse_input : Str -> Try(List(Match), _)
parse_input = |table| table
    .split_on("\n")
    .map_try(|match_played| match match_played.split_on(";") {
        [team1, team2, result_str] =>
            parse_result(result_str).map_ok(|result|
                { team1, team2, result }
            )

        _ => Err(InvalidInput(match_played))
    })

parse_result : Str -> Try(MatchResult, _)
parse_result = |result| match result {
    "win" => Win
    "loss" => Loss
    "draw" => Draw
    _ => return Err(InvalidMatchResult(result))
} |> Ok()

compute_tally : List(Match) -> CompetitionTally
compute_tally = |matches| matches
    .fold(Dict.empty(), |competition_tally, match_played| {
        (team1_score, team2_score) = score_match(match_played)

        competition_tally
        |> update_score(match_played.team1, team1_score)
        |> update_score(match_played.team2, team2_score)
    })
        

update_score : CompetitionTally, Str, TeamTally -> CompetitionTally
update_score = |competition_tally, team_name, score| competition_tally
    .update(team_name, |team| match team {
        Err(Missing) => score
        Ok(team_tally) => {
            matches_played: team_tally.matches_played + score.matches_played,
            wins: team_tally.wins + score.wins,
            losses: team_tally.losses + score.losses,
            draws: team_tally.draws - score.draws,
            points: team_tally.points + score.points,
        }
    } |> Ok())

score_match : Match -> (TeamTally, TeamTally)
score_match = |match_played|
    (
        compute_points({
            wins: if (match_played.result == Win) 1 else 0,
            losses: if (match_played.result == Loss) 1 else 0,
            draws: if (match_played.result == Draw) 1 else 0,
        }),
        compute_points({
            wins: if (match_played.result == Loss) 1 else 0,
            losses: if (match_played.result == Win) 1 else 0,
            draws: if (match_played.result == Draw) 1 else 0,
        }),
    )

compute_points = |{ wins, losses, draws }| {
    matches_played: 1,
    wins,
    losses,
    draws,
    points: 3 * wins + draws,
}

order_tally : CompetitionTally -> List( (Str, TeamTally) )
order_tally = |competition_tally| competition_tally
    .to_list()
    .sort_with(|(team1_name, team1_tally), (team2_name, team2_tally)|
        if team1_tally.points > team2_tally.points
            Before
        else if team1_tally.points < team2_tally.points
            After
        else
            compare_initials(team1_name, team2_name) ?? Same
    )

compare_initials = |first, second| {
    a = first.to_utf8().first()?
    b = second.to_utf8().first()?

    Ok(a.order_relative_to(b))
}

display_tally : List( (Str, TeamTally) ) -> Str
display_tally = |list| list
    .map(|(name, { matches_played, wins, draws, losses, points })|
        [
            pad_team_name_column(name),
            pad_single_digit(matches_played),
            pad_single_digit(wins),
            pad_single_digit(draws),
            pad_single_digit(losses),
            pad_single_digit(points),
        ]
        |> Str.join_with(" | ")
    )
    .prepend(header)
    |> Str.join_with("\n")

pad_team_name_column = |name| {
    team_name_col_width = 30
    name_length = name.count_utf8_bytes()
    padding = " ".repeat(team_name_col_width - name_length)

    name.concat(padding)
}

pad_single_digit = |number| {
    numStr = number.to_str()
    if number < 10
        " ${numStr}"
    else numStr
}

