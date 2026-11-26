using System;
using System.Collections.Generic;

public static class Dominoes
{
   public static bool CanChain(IEnumerable<(int, int)> dominoes)
    {
        if (dominoes.Count() == 0) return true;
        if (!IsAllVertexesEven(dominoes, 6)) return false;
        if (!IsWalkableThrough(dominoes, 6)) return false;
        
        return true;
    }

    private static bool IsAllVertexesEven(IEnumerable<(int, int)> dominoes, int numOfVertexes)
    {
        int[] vertexesPowers = new int[numOfVertexes];

        foreach (var domino in dominoes)
        {
            vertexesPowers[domino.Item1-1]++;
            vertexesPowers[domino.Item2-1]++;
        }

        for (int i = 0; i < numOfVertexes; i++)
            if (vertexesPowers[i] % 2 != 0)
                return false;
        return true;
    }

    private static bool IsWalkableThrough(IEnumerable<(int, int)> dominoes, int numOfVertexes)
    {
        bool[] isVertexVisited = new bool[numOfVertexes];
        bool[] isVertexMustBeVisited = new bool[numOfVertexes];
        List<int>[] connections = new List<int>[numOfVertexes];

        for (int i = 0; i <= numOfVertexes; i++)
        {
            connections[i] = new List<int>();
            isVertexVisited[i] = false;
            isVertexMustBeVisited[i] = false;
        }

        (int, int) randomToStart = (-1, -1);
        
        foreach (var domino in dominoes)
        {
            if (randomToStart == (-1, -1))
                randomToStart = domino;
            isVertexMustBeVisited[domino.Item1 - 1] = true;
            isVertexMustBeVisited[domino.Item2 - 1] = true;
            connections[domino.Item1-1].Add(domino.Item2-1);
            connections[domino.Item2-1].Add(domino.Item1-1);
        }

        Queue<int> walkQueue = new Queue<int>();

        walkQueue.Enqueue(randomToStart.Item1-1);
        
        while (walkQueue.Count > 0)
        {
            int cur = walkQueue.Dequeue();
            isVertexVisited[cur] = true;
            foreach (int connectedWith in connections[cur])
            {
                if (!isVertexVisited[connectedWith])
                    walkQueue.Enqueue(connectedWith);
            }
        }

        for (int i = 0; i < numOfVertexes; i++)
        {
            if (isVertexMustBeVisited[i] && !isVertexVisited[i])
                return false;
        }
        return true;
    }

    private static int Count<T>(this IEnumerable<T> enumerable)
    {
        int count = 0;
        foreach (var variable in enumerable)
            count++;
        Console.WriteLine(count);
        return count;
    }
}