# Use the Plot struct as it is provided
defmodule Plot do
  @enforce_keys [:plot_id, :registered_to]
  defstruct     [:plot_id, :registered_to]
end

defmodule CommunityGarden do
  def start(opts \\ []) do
    Agent.start(fn -> {1, []} end, opts)
  end

  def list_registrations(pid) do
    Agent.get(pid, fn {_last_id, plots} -> plots end)
  end

  def register(pid, register_to) do
    Agent.get_and_update(pid, fn {last_id, plots} -> # get_and_update used so that registering is concurrent
      new_plot = %Plot{plot_id: last_id, registered_to: register_to} # build the new plot
      {new_plot, {last_id+1, [new_plot | plots]}} # {the new plot to return, the new state to bind to the agent}
      end)
  end

  def release(pid, plot_id) do
    plots_without = list_registrations(pid)
    |> Enum.filter(fn %{plot_id: ^plot_id} -> false # drop the plot that matches the id
                                         _ -> true end)
    Agent.update(pid, fn {last_id, _plots} -> {last_id, plots_without} end)
  end

  def get_registration(pid, plot_id) do
    list_registrations(pid)
    |> Enum.find(fn plot -> plot.plot_id == plot_id end)
    |> case do
        nil -> {:not_found, "plot is unregistered"}
        plot -> plot
       end
  end
end
