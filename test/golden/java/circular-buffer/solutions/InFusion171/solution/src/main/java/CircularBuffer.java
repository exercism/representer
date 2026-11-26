import java.util.*;
import java.util.stream.IntStream;

class CircularBuffer<T> {
    public class DataContainer<T>
{
    private final T data;
    private int age;

    DataContainer(T data)
    {
        this.data = data;
        this.age = 0;
    }

    public T getData()
    {
        return this.data;
    }

    public int getAge()
    {
        return this.age;
    }

    public void increaseAge()
    {
        this.age++;
    }

    @Override
    public String toString()
    {
        return "{data: " + data + " | age: " + age + "}";
    }
}

    
    private final List<DataContainer<T>> buffer;
    private final int SIZE;

    CircularBuffer(final int size) {
        SIZE = size;
        buffer = new ArrayList<>(size);
    }

    /**
     * Read the oldest element from buffer and removes it from the buffer
     * 
     * @return The removed and oldest element
     * @throws BufferIOException If we want to read from an empty buffer
     */
    T read() throws BufferIOException
    {
        if (buffer.isEmpty())
        {
            throw new BufferIOException("Tried to read from empty buffer");
        }

       int oldestIndex = getOldestIndex();

       if (oldestIndex == -1)
       {
           throw new BufferIOException("Tried to read from empty buffer");
       }

       return buffer.remove(oldestIndex).getData();
    }

    /**
     * Write data to the buffer
     * 
     * @param data To be written
     * @throws BufferIOException Throws if the buffer is full
     */
    void write(T data) throws BufferIOException {
        if (buffer.size() == SIZE)
        {
            throw new BufferIOException("Tried to write to full buffer");
        }

        // increase age for every element
        buffer.forEach(DataContainer::increaseAge);

        buffer.add(new DataContainer<>(data));
    }

    /**
     * Add data if buffer isn't full or overwrite the oldest element with data
     * 
     * @param data Data to be added
     * @throws BufferIOException Throws if write operations fails
     */
    void overwrite(T data) throws BufferIOException
    {
        if (buffer.size() < SIZE)
        {
            write(data);
        }
        else
        {
            buffer.forEach(DataContainer::increaseAge);
            buffer.set(getOldestIndex(), new DataContainer<>(data));
        }
    }

    void clear()
    {
       buffer.clear();
    }

    /**
     * Get the oldest index from buffer.
     * Returns -1 if buffer is empty
     *
     * @return oldest index
     */
    private int getOldestIndex()
    {
        // create a int stream in range from  to buffer.size, get the index of the oldest element with a custom comparator
        return IntStream.range(0, buffer.size())
                .boxed()
                .max(Comparator.comparing(i -> buffer.get(i).getAge()))
                .orElse(-1);

    }
}