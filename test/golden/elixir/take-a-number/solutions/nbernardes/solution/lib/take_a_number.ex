defmodule TakeANumber do
  @initial_state 0

  def start do
    spawn(&loop/0)
  end

  defp loop(state \\ @initial_state) do
    receive do
      {:report_state, sender_pid} ->
        send(sender_pid, state)
        loop(state)

      {:take_a_number, sender_pid} ->
        state = state + 1
        send(sender_pid, state)
        loop(state)

      :stop ->
        exit("Stop the machine")

      _ ->
        loop(state)
    end
  end
end
