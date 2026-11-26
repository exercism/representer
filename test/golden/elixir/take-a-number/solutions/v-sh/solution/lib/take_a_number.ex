defmodule TakeANumber do
  def start() do
    spawn(TakeANumber, :loop, [0])
  end

  def loop(n) do
    receive do
      {:report_state, sender_pid} ->
        send(sender_pid, n)
        loop(n)
      {:take_a_number, sender_pid} ->
        n = n + 1
        send(sender_pid, n)
        loop(n)
      :stop -> :ok
      _msg -> loop(n)
    end
  end
end
