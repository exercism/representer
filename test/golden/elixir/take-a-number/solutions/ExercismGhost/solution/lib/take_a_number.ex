defmodule TakeANumber do
  def start() do
    spawn(fn -> process(0) end)
  end

  defp process(ticket) do
    receive do
      {:report_state, sender_pid} ->
        send(sender_pid, ticket)
        process(ticket)
      {:take_a_number, sender_pid} ->
        send(sender_pid, ticket+1)
        process(ticket+1)
      :stop -> nil
      _ -> process(ticket)
    end
  end
end
