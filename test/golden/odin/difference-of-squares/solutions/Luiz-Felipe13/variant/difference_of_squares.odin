package difference_of_squares

@(require_results) square_of_sum  :: #force_inline proc "contextless" (n: int) -> int {res := n * (n + 1) / 2; return res * res}
@(require_results) sum_of_squares :: #force_inline proc "contextless" (n: int) -> int {return n * (n + 1) * (2 / n + 1) / 6}
@(require_results) difference     :: #force_inline proc "contextless" (n: int) -> int {return square_of_sum(n) - sum_of_squares(n)}
