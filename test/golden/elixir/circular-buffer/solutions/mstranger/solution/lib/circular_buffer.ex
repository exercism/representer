defmodule CircularBuffer do
  @moduledoc """
  An API to a stateful process that fills and empties a circular buffer
  """

  use GenServer

  @doc """
  Create a new buffer of a given capacity
  """
  @spec new(capacity :: integer) :: {:ok, pid}
  def new(capacity) do
    GenServer.start_link(__MODULE__, capacity)
  end

  @doc """
  Read the oldest entry in the buffer, fail if it is empty
  """
  @spec read(buffer :: pid) :: {:ok, any} | {:error, atom}
  def read(buffer) do
    GenServer.call(buffer, :read)
  end

  @doc """
  Write a new item in the buffer, fail if is full
  """
  @spec write(buffer :: pid, item :: any) :: :ok | {:error, atom}
  def write(buffer, item) do
    GenServer.call(buffer, {:write, item})
  end

  @doc """
  Write an item in the buffer, overwrite the oldest entry if it is full
  """
  @spec overwrite(buffer :: pid, item :: any) :: :ok
  def overwrite(buffer, item) do
    case write(buffer, item) do
      {:error, :full} -> GenServer.call(buffer, {:overwrite, item})
      :ok -> :ok
    end
  end

  @doc """
  Clear the buffer
  """
  @spec clear(buffer :: pid) :: :ok
  def clear(buffer) do
    GenServer.cast(buffer, :clear)
  end

  # -- server side --

  @impl true
  def init(capacity) do
    buffer = for _ <- 1..capacity, do: []
    state = %{buffer: buffer, start: 0, stop: 0, cap: capacity}
    {:ok, state}
  end

  @impl true
  def handle_call(:read, _from, state) do
    {response, state} =
      case Enum.at(state.buffer, state.start) do
        [] ->
          {{:error, :empty}, state}

        [data] ->
          buffer = List.update_at(state.buffer, state.start, fn _ -> [] end)
          state = %{state | buffer: buffer, start: rem(state.start + 1, state.cap)}
          {{:ok, data}, state}
      end

    {:reply, response, state}
  end

  @impl true
  def handle_call({:write, item}, _from, state) do
    data = Enum.at(state.buffer, state.stop)

    {response, state} =
      case data do
        [] ->
          buffer = List.update_at(state.buffer, state.stop, fn _ -> [item] end)
          state = %{state | buffer: buffer, stop: rem(state.stop + 1, state.cap)}
          {:ok, state}

        [_] ->
          {{:error, :full}, state}
      end

    {:reply, response, state}
  end

  @impl true
  def handle_call({:overwrite, item}, _from, state) do
    buffer = List.update_at(state.buffer, state.stop, fn _ -> [item] end)
    stop = rem(state.stop + 1, state.cap)
    start = rem(state.start + 1, state.cap)
    state = %{state | buffer: buffer, stop: stop, start: start}

    {:reply, :ok, state}
  end

  @impl true
  def handle_cast(:clear, state) do
    {:ok, new_state} = init(state.cap)
    {:noreply, new_state}
  end
end
