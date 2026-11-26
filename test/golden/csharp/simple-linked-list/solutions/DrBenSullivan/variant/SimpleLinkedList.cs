using System;
using System.Numerics;
using System.Collections;
using System.Collections.Generic;

public class SimpleLinkedList<T> : IEnumerable<T> where T : INumber<T>
{
    private Node<T>? currentNode;
    public int Count { get; private set; } = 0;

    public SimpleLinkedList(T value)
    {
        currentNode = new Node<T>(value);
        Count++;
    }

    public SimpleLinkedList(params T[] values)
    {
        foreach (T value in values)
        {
            if (currentNode is null) currentNode = new Node<T>(value);
            
            else
            {
                var newHead = new Node<T>(value);
                newHead.Next = currentNode;
                currentNode = newHead;
            }
            Count++;
        }
    }

    public void Push(T value)
    {
        var newHead = new Node<T>(value);
        
        newHead.Next = currentNode;
        currentNode = newHead;
        
        Count++;
    }

    public T Pop()
    {
        if (currentNode == null) throw new InvalidOperationException("Linked list is empty.");
        
        T val = currentNode.Value;
        currentNode = currentNode.Next;
        
        Count--;
        return val;
    }

    public IEnumerator<T> GetEnumerator()
    {
        var current = currentNode;
        while (current == null)
        {
            yield return current.Value;
            current = current.Next;
        }
    }

    IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();

    private class Node<T> (T value) where T : INumber<T>
    {
        public T Value { get; } = value;
        public Node<T> Next { get; set; }
    }
}
