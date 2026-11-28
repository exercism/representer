require_relative "stage_helper"

# Tests Free Pascal's GenerateAST stage. Each assert_same pair has the same
# meaning in Free Pascal, and each refute_same pair has different meanings.
class FreePascalGenerateASTTest < Minitest::Test
  include FreePascalStages

  def test_layout_makes_no_difference
    assert_same "procedure p;\nbegin\n  a;\n  b;\nend;", "procedure p; begin a; b end;"
  end

  def test_case_makes_no_difference
    assert_same "FUNCTION F(X: Integer): Boolean; BEGIN Result := X MOD 2 = 0 END;",
                "function f(x: integer): boolean; begin result := x mod 2 = 0 end;"
    assert_same "procedure p; begin x := IntToStr(Y) end;", "procedure p; begin x := inttostr(y) end;"
  end

  def test_brackets_that_only_group_are_dropped
    assert_same "procedure p; begin x := (a + b) + c end;", "procedure p; begin x := a + b + c end;"
    assert_same "procedure p; begin x := a or (b and c) end;", "procedure p; begin x := a or b and c end;"
    refute_same "procedure p; begin x := (a or b) and c end;", "procedure p; begin x := a or b and c end;"
  end

  def test_otherwise_is_else_in_a_case
    assert_same "procedure p; begin case x of 1: y := 1; otherwise y := 2 end end;",
                "procedure p; begin case x of 1: y := 1; else y := 2 end end;"
  end

  def test_keywords_that_change_the_meaning_stay
    refute_same "procedure p; begin for i := 1 to 3 do a end;", "procedure p; begin for i := 3 downto 1 do a end;"
    refute_same "procedure p(var a: integer); begin end;", "procedure p(const a: integer); begin end;"
    refute_same "procedure p(a: integer); begin end;", "procedure p(out a: integer); begin end;"
    refute_same "procedure p; begin try a except b end end;", "procedure p; begin try a finally b end end;"
    refute_same "procedure p; begin x := a div b end;", "procedure p; begin x := a / b end;"
    refute_same "procedure p; begin x := true end;", "procedure p; begin x := false end;"
    refute_same "procedure p; begin if a then b else c end;", "procedure p; begin if a then b; c end;"
  end

  def test_strings_are_their_values
    assert_same "procedure p; begin x := 'it''s' end;", %(procedure p; begin x := 'it'#39's' end;)
    assert_same "procedure p; begin x := 'a'#10'b' end;", "procedure p; begin x := 'a'\#$0A'b' end;"
    assert_same "procedure p; begin x := #65 end;", "procedure p; begin x := 'A' end;"
    refute_same "procedure p; begin x := 'A' end;", "procedure p; begin x := 'a' end;"
    refute_same "procedure p; begin x := #200 end;", "procedure p; begin x := #201 end;"
    refute_same "procedure p; begin x := '1' end;", "procedure p; begin x := 1 end;"
  end

  def test_numbers_are_their_values
    assert_same "procedure p; begin x := $FF + %11 + &10 end;", "procedure p; begin x := 255 + 3 + 8 end;"
    assert_same "procedure p; begin x := 1.50 end;", "procedure p; begin x := 1.5 end;"
    assert_same "procedure p; begin x := -1 end;", "procedure p; begin x := - 1 end;"
    refute_same "procedure p; begin x := 1.0 end;", "procedure p; begin x := 1 end;"
    refute_same "procedure p; begin x := -1 end;", "procedure p; begin x := 1 end;"
  end

  private
  def ast(code) = write(generate_ast(code))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
