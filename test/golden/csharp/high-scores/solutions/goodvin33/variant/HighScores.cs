using System;
using System.Collections.Generic;
using System.Linq;

  public class HighScores
    {
        private List<int> ListScores { get; set; }


        public HighScores(List<int> list)
        {
            ListScores = list;
        }

        public List<int> Scores() => ListScores;

        public int Latest() => ListScores.Last();

        public int PersonalBest() => ListScores.Max();

        public List<int> PersonalTopThree() => ListScores.OrderByDescending(x => x).Take(4).ToList();
    }