hamming <- function(strand1, strand2) {
  c(a=strand1, b=strand2) |>
    strsplit("") |> data.frame() |>
    with(a != b) |> sum()
}
