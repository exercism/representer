tournament <- function(input) {
  # split input into teams involved
  input_split <- lapply(input, function(x) unlist(strsplit(x, ';')))
  # discard rows that aren't composed of three elements
  valid_length_inputs <- input_split[sapply(input_split, function(x) length(x) == 3)]
  input_table <- t(simplify2array(valid_length_inputs))
  all_teams <- unique(c(input_table[,1:2]))
  
  score_df <- data.frame(Team = all_teams, MP=NA,  W=NA, D=NA, L=NA, P=NA, row.names = all_teams)

  win_rows <- input_table[,3] == 'win'
  loss_rows <- input_table[,3] == 'loss'
  draw_rows <- input_table[,3] != 'draw'
  
  for (team in all_teams){
    team_col_1 <- input_table[,1] == team
    team_col_2 <- input_table[,2] == team
    
    score_df[team, 'W'] = sum((team_col_1 & win_rows) | (team_col_2 & loss_rows)) # wins
    score_df[team, 'L'] = sum((team_col_1 & loss_rows) | (team_col_2 & win_rows)) # losses
    score_df[team, 'D'] = sum((team_col_1 | team_col_2) & draw_rows) # draws
  }
  
  score_df$MP <- rowSums(score_df[,3:5]) # total matches played
  score_df$P <- score_df$W * 3 + score_df$D * 1 # point calculation
  
  score_df <- score_df[order(score_df$P, score_df$Team, decreasing = c(TRUE, FALSE), method = "radix"), ]

  row.names(score_df) <- NULL
  
  return(score_df)
  
}
