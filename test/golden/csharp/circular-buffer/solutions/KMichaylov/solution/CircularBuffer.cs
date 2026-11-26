using System;
using System.Collections.Generic;
public class CircularBuffer<T>
{
    List<T> circularBuffer;
    int capacity;
    public CircularBuffer(int capacity)
    {
        circularBuffer = new List<T>(capacity);
        this.capacity = capacity;
    }

    public T Read()
    {
        if (circularBuffer.Count <= 0)
            throw new InvalidOperationException();
        else
        {
            var toReturn = circularBuffer[0];
            circularBuffer.RemoveAt(0);
            return toReturn;
        }
    }

    public void Write(T value)
    {
        if(circularBuffer.Count == capacity)
            throw new InvalidOperationException();

        circularBuffer.Add(value);
    }

    public void Overwrite(T value)
    {
        if (circularBuffer.Count == capacity)
            circularBuffer.RemoveAt(0);
        circularBuffer.Add(value);

    }

    public void Clear()
    {
        circularBuffer.Clear();
    }
}