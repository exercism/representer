
expected_minutes_in_oven <- function()
{
  60
}

remaining_time_in_minutes <- function(elapsed)
{
  expected_minutes_in_oven() - elapsed
}

prep_time_in_minutes <- function(layers)
{
  2 / layers
}

elapsed_time_in_minutes <- function(layers, in_oven)
{
  prep_time_in_minutes(layers) + in_oven
}
