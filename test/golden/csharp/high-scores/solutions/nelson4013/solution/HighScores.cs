using System;
using System.Collections.Generic;
using System.Linq;

public class HighScores
{
    private List<int> _list;
    public HighScores(List<int> list)
    {
        _list = list;
    }

    public List<int> Scores()
    {
       return _list;
    }

    public int Latest()
    {        
        return _list.Last();
    }

    public int PersonalBest()
    {
        return _list.OrderByDescending(i => i).FirstOrDefault();
    }

    public List<int> PersonalTopThree()
    {
        return _list.OrderByDescending(i => i).Take(3).ToList();
        //return _list.Take(3).ToList();
    }
}