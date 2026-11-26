use context essentials2020

provide: high-scores end

data HighScores: high-scores(scores :: List<NumInteger>)
with:
  method latest(self) -> NumInteger:
    doc: "Returns the last score added. If no scores are present, returns 0."
    if is-empty(self.scores):
      0
    else:
      self.scores.get(self.scores.length() - 1)
    end
  end,
  
  method personal-best(self) -> NumInteger:
    doc: "Returns the highest score. Starts fold with the first score for efficiency and robustness."
    if is-empty(self.scores):
      0
    else:
      self.scores.foldl(lam(score, max): num-max(max, score) end, self.scores.get(0))
    end
  end,
  
  method personal-top-three(self) -> List<NumInteger>:
    doc: "Returns the top three scores in descending order. Simplifies sorting operation."
    sorted = self.scores.sort-by({(a, b): a > b}, {(a, b): a == b})
    sorted.take(num-min(3, sorted.length()))
  end
end
