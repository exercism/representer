defmodule TakeANumber do
  defp loop(state) do
      IO.puts("loop")
      receive do
         message -> handle(message, state)
      end
      |> case do
          {:continue, state} -> loop(state)
          {:stop, _state} -> :noop
        end
  end

  defp handle({:report_state, pid}, state) do
    send(pid, state)
    {:continue, state}
  end

  defp handle({:take_a_number, pid}, state) do
    new_state = state + 1
    send(pid, new_state)
    {:continue, new_state}
  end

  defp handle(:stop, state) do
    {:stop, state}
  end

  defp handle(_other, state) do
    {:continue, state}
  end

  def start() do
    spawn(fn -> loop(0) end)
  end
end
