using System.Collections.Generic;
using System.Linq;

public class CustomSet
{
    private HashSet<int> _list;

    public CustomSet(params int[] values)
    {
        _list = new HashSet<int>();
        foreach (var value in values) Add(value);
    }

    public CustomSet Add(int value)
    {
        _list.Add(value);
        return this;
    }

    public bool Empty() => !_list.Any();

    public bool Contains(int value) => _list.Contains(value);

    public bool Subset(CustomSet right)
    {
        foreach (var node in _list) if (!right.Contains(node)) return false;
        return true;
    }

    public bool Disjoint(CustomSet right)
    {
        foreach (var node in _list) if (right.Contains(node)) return false;
        return true;
    }

    public CustomSet Intersection(CustomSet right)
    {
        var intersection = new CustomSet();
        foreach (var node in _list) if (right.Contains(node)) intersection.Add(node);
        return intersection;
    }

    public CustomSet Difference(CustomSet right)
    {
        var difference = new CustomSet();
        foreach (var node in _list) if (!right.Contains(node)) difference.Add(node);
        return difference;
    }

    public CustomSet Union(CustomSet right)
    {
        var union = new CustomSet();
        foreach (var node in _list) union.Add(node);
        foreach (var node in right._list) union.Add(node);
        return union;
    }

    public override bool Equals(object right)
    {
        if (!(right is CustomSet)) return false;
        var rightCustomSet = (CustomSet)right;

        if (!(_list.Count != rightCustomSet._list.Count)) return false;

        foreach (var item in _list) if (!rightCustomSet.Contains(item)) return false;
        return true;
    }

    public override int GetHashCode()
    {
        return base.GetHashCode();
    }
}
