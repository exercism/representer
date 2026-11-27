require_relative "stage_helper"

# Checks which names Scheme's GenerateAST marks as defined (see
# scheme/representation.rb), through the engine's renaming.
class SchemeNamesTest < Minitest::Test
  include SchemeStages

  def test_renames_definitions_and_their_parameters
    assert_equal %w[area h rest total w], renamed("(define total 0)\n(define (area w h . rest) (* w h))")
    assert_equal %w[adder n x], renamed("(define ((adder n) x) (+ n x))")
  end

  def test_renames_the_parameters_of_lambdas
    assert_equal %w[args f], renamed("(define f (lambda args (car args)))")
    assert_equal %w[a b f], renamed("(define f (case-lambda ((a) a) ((a b) (+ a b))))")
    assert_equal %w[a b f], renamed("(define* (f a #:optional (b 1)) (list a b))")
  end

  def test_renames_local_bindings
    assert_equal %w[acc i loop], renamed("(let loop ((i 0) [acc '()]) (if (< i 3) (loop (+ i 1) (cons i acc)) acc))")
    assert_equal %w[x y], renamed("(let* ((x 1) (y x)) y)")
    assert_equal %w[q r], renamed("(let-values (((q r) (div-and-mod 7 2))) q)")
    assert_equal %w[a more], renamed("(receive (a . more) (values 1 2) a)")
    assert_equal %w[n1 n2], renamed("(define-values (n1 n2) (div-and-mod 7 2))")
    assert_equal %w[k], renamed("(do ((k 0 (+ k 1))) ((= k 3)) (display k))")
    assert_equal %w[e], renamed("(guard (e (#t e)) (raise 'oops))")
  end

  def test_renames_the_names_of_records
    source = "(define-record-type <point> (make-point x y) point? (x point-x) (y point-y set-point-y!))"
    assert_equal %w[<point> make-point point-x point-y point? set-point-y! x y], renamed(source)
    assert_equal %w[pt px py py-get py-set!], renamed("(define-record-type pt (fields px (mutable py py-get py-set!)))")
  end

  def test_renames_macros_and_their_pattern_variables
    source = "(define-syntax swap! (syntax-rules () ((_ a b) (let ((tmp a)) (set! a b) (set! b tmp)))))"
    assert_equal %w[a b swap! tmp], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal %w[f s], renamed("(define (f s) (string-upcase (string-append s \"!\")))")
  end

  def test_renames_library_names_the_solution_defines
    assert_equal %w[f square x], renamed("(define (square x) (* x x))\n(define (f x) (square x))")
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Representer::Engine::RenameUserDefinedNodes.([tree], Scheme::Representation)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if Scheme::Representation.name?(node) }
    leaves
  end
end
