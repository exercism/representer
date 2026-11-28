require_relative "stage_helper"

# Checks Racket's declarations of which nodes are names and which nodes
# define them (see racket/representation.rb), through the engine's
# renaming.
class RacketNamesTest < Minitest::Test
  include RacketStages

  def test_renames_functions_and_their_parameters
    source = "(define (f a [b 1] #:by [c 2] . rest) a)\n(define ((g x) y) x)\n(define limit 10)"
    assert_equal %w[a b c f g limit rest x y], renamed(source)
  end

  def test_renames_lambda_parameters
    assert_equal %w[args f x y], renamed("(define f (lambda (x) (λ args (case-lambda [(y) y]))))")
  end

  def test_renames_local_bindings
    source = "(let loop ([i 0]) (let* ([j i]) (letrec ([k j]) (let-values ([(q r) (values 1 2)]) (let/ec out k)))))"
    assert_equal %w[i j k loop out q r], renamed(source)
  end

  def test_renames_loop_variables_and_accumulators
    source = "(for/fold ([total 0] #:result (f total)) ([x xs] #:when (odd? x)) (+ total x))\n" \
             "(for ([(k v) h]) k)\n(do ([n 0 (add1 n)]) ((> n 3)) n)"
    assert_equal %w[k n total v x], renamed(source)
  end

  def test_renames_the_names_a_match_pattern_binds
    source = "(match xs [(list a (? number? b)) a] [(cons h t) h] ['(c d) 1] [_ 0] [else 1])"
    assert_equal %w[a b h t], renamed(source)
  end

  def test_renames_structures_and_their_fields
    assert_equal %w[point point3 x y z], renamed("(struct point (x [y #:mutable]))\n(struct point3 point (z))")
  end

  def test_renames_classes_fields_and_methods
    source = "(define robot% (class object% (super-new) (init-field name [age 0]) (field [seen 0])\n" \
             "  (define/public (greet) name)))"
    assert_equal %w[age greet name robot% seen], renamed(source)
  end

  def test_renames_macros_and_their_pattern_variables
    assert_equal %w[a b swap! tmp], renamed("(define-syntax-rule (swap! a b) (let ([tmp a]) (set! a b)))")
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal %w[f x], renamed("(define (f x) (string-upcase (first (rest x))))\n(parameterize ([current-output-port x]) 1)")
  end

  def test_a_quoted_form_defines_nothing
    assert_equal [], renamed("'(define x 1)")
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source)
    tree = prepare(source)
    Rosetta::Engine::RenameUserDefinedNodes.([tree], Racket::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << node.text if Racket::Representation::Spec.name?(node) && node.renamed }
    leaves.uniq.sort
  end
end
