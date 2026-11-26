class HighScores:
    def __init__(self, scores):
        self.scores = scores

    def scores(self):
        return self.scores

    def latest(self):
        return self.scores[-1]
        # return self.scores[len(self.scores)-1]

    def personal_best(self):
        return max(self.scores)

    def personal_top_three(self):
        scores_copy = self.scores.copy()
        scores_copy.sort(reverse=True)
        
        if len(scores_copy) == 1:
            return [scores_copy[0]]
        
        elif len(scores_copy) == 2:
            return [scores_copy[0], scores_copy[1]]
        
        return scores_copy[0:3]