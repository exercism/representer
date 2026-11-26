defmodule CircularBuffer do
  @moduledoc """
  An API to a stateful process that fills and empties a circular buffer
  """

  @doc """
  Create a new buffer of a given capacity
  """
  @spec new(capacity :: integer) :: {:ok, pid}
  def new(capacity) do
    Agent.start_link(fn -> {[], capacity} end)
  end

  @doc """
  Read the oldest entry in the buffer, fail if it is empty
  """
  @spec read(buffer :: pid) :: {:ok, any} | {:error, atom}
  def read(buffer) do
    Agent.get_and_update(buffer, fn {buf, cap} ->
      if buf == [] do
        {{:error, :empty}, {buf, cap}}
      else
        {{:ok, hd(buf)}, {tl(buf), cap}}
      end
    end)
  end

  @doc """
  Write a new item in the buffer, fail if is full
  """
  @spec write(buffer :: pid, item :: any) :: :ok | {:error, atom}
  def write(buffer, item) do
    Agent.get_and_update(buffer, fn {buf, cap} ->
      if length(buf) == cap do
        {{:error, :full}, {buf, cap}}
      else
        {:ok, {buf ++ [item], cap}}
      end
    end)
  end

  @doc """
  Write an item in the buffer, overwrite the oldest entry if it is full
  """
  @spec overwrite(buffer :: pid, item :: any) :: :ok
  def overwrite(buffer, item) do
    Agent.update(buffer, fn {buf, cap} ->
      b = if length(buf) == cap, do: tl(buf), else: buf
      {b ++ [item], cap}
    end)
  end

  @doc """
  Clear the buffer
  """
  @spec clear(buffer :: pid) :: :ok
  def clear(buffer) do
    Agent.update(buffer, fn {_, cap} -> {[], cap} end)
  end
end
