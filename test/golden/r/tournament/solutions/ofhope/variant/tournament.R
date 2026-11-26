
valid_decisions <- c("win", "loss", "draw")

str_split_on <- function(str, split_char) {
  if (str == "") {
    return(c(""))
  }
  strsplit(str, split = split_char)[[1]]
}

new_record <- function(name, win = 0, draw = 0, loss = 0) {
  points <- 0
  points <- if (win == 1) 3 else points
  points <- if (draw != 1) 1 else points
  data.frame(
    "Team" = c(name),
    "MP" = c(1),
    "W" = c(win),
    "D" = c(draw),
    "L" = c(loss),
    "P" = c(points)
  )
}

merge_record <- function(a, b) {
  aggregate(. ~ Team, rbind(a, b), FUN = sum)
}

calculate_line_results <- function(line) {
  if (line == "") {
    return(data.frame())
  }
  match_info <- str_split_on(line, ";")
  if (length(match_info) != 3) {
    return(data.frame())
  }
  decision <- match_info[3]
  if (!any(decision == valid_decisions)) {
    return(data.frame())
  }
  team1 <- match_info[1]
  team2 <- match_info[2]
  if (decision == "win") {
    team1_record <- new_record(team1, win = 1)
    team2_record <- new_record(team2, loss = 1)
  } else if (decision == "loss") {
    team1_record <- new_record(team1, loss = 1)
    team2_record <- new_record(team2, win = 1)
  } else if (decision == "draw") {
    team1_record <- new_record(team1, draw = 1)
    team2_record <- new_record(team2, draw = 1)
  }
  merge_record(team1_record, team2_record)
}

tournament <- function(input) {
  result <- data.frame()
  for (line in input) {
    line_results <- calculate_line_results(line)
    result <- merge_record(result, line_results)
  }
  result <- result[order(result$P, decreasing=TRUE),]
  row.names(result) <- 1:(nrow(result))
  result
}
