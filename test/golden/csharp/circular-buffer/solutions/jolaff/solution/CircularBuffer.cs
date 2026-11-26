using System;
using System.Linq;
using System.Collections.Generic;

public class CircularBuffer<T>
{
    private List<T> _circularBuffer;
    private readonly int _capacity;

    public CircularBuffer(int capacity)
    {
        _circularBuffer = new List<T>(capacity);
        _capacity = capacity;
    }

    public T Read()
    {
        if (_circularBuffer.Count == 0)
            throw new InvalidOperationException();

        var value = _circularBuffer[0];
        DequeueHead();
        return value;
    }

    public void Write(T value)
    {
        if (_circularBuffer.Count == _capacity)
            throw new InvalidOperationException();

        _circularBuffer.Add(value);
    }

    public void Overwrite(T value)
    {
        if (_circularBuffer.Count == _capacity)
            DequeueHead();

        Write(value);
    }

    public void Clear() => _circularBuffer.Clear();

    private void DequeueHead() => _circularBuffer = _circularBuffer.Skip(1).ToList();
}