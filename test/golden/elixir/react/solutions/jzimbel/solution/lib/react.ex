defmodule React do
  @moduledoc """
  Developer API with functions to create and manipulate a reactive system.
  """

  @type cell_name :: String.t()
  @type callback_name :: String.t()
  @type value :: any

  @type cell ::
          {:input, cell_name, value}
          | {:output, cell_name, dependencies :: [cell_name], fun()}

  @doc """
  Start a reactive system
  """
  @spec new([cell]) :: {:ok, React.System.system()}
  defdelegate new(cells), to: React.System

  @doc """
  Return the value of an input or compute cell
  """
  @spec get_value(React.System.system(), cell_name) :: value
  defdelegate get_value(system, cell_name), to: React.System

  @doc """
  Set the value of an input cell
  """
  @spec set_value(React.System.system(), cell_name, value) :: :ok
  defdelegate set_value(system, input_cell_name, value), to: React.System

  @doc """
  Add a callback to a compute cell
  """
  @spec add_callback(
          React.System.system(),
          cell_name,
          callback_name,
          callback :: (callback_name, value -> any)
        ) :: :ok
        when callback_name: String.t()
  defdelegate add_callback(system, compute_cell_name, callback_name, callback), to: React.System

  @doc """
  Remove a callback from a compute cell
  """
  @spec remove_callback(React.System.system(), cell_name, callback_name) :: :ok
  defdelegate remove_callback(system, compute_cell_name, callback_name), to: React.System
end

defmodule React.System do
  @moduledoc """
  Functions to create and manipulate a reactive system.
  """

  use GenServer

  @opaque system :: pid

  @type cell_type :: :input | :compute

  @type t :: %__MODULE__{
          cells: %{React.cell_name() => {cell_type, pid}}
        }

  @enforce_keys ~w[cells]a
  defstruct @enforce_keys

  # Client

  def new(cells) do
    GenServer.start_link(__MODULE__, cells)
  end

  def get_value(system, cell_name) when is_pid(system) do
    GenServer.call(system, {:get_value, cell_name})
  end

  def set_value(system, input_cell_name, value) do
    GenServer.cast(system, {:set_value, input_cell_name, value})
  end

  def add_callback(system, compute_cell_name, callback_name, callback)
      when is_function(callback, 2) do
    GenServer.cast(system, {:add_callback, compute_cell_name, callback_name, callback})
  end

  def remove_callback(system, compute_cell_name, callback_name) do
    GenServer.cast(system, {:remove_callback, compute_cell_name, callback_name})
  end

  # Server

  @impl true
  def init(cell_defs) do
    {:ok, start_system(cell_defs)}
  end

  @impl true
  def handle_call({:get_value, cell_name}, _from, state) do
    value =
      case state.cells[cell_name] do
        {:input, cell} -> React.InputCell.get_value(cell)
        {:compute, cell} -> React.ComputeCell.get_value(cell)
        nil -> nil
      end

    {:reply, value, state}
  end

  @impl true
  def handle_cast({:set_value, input_cell_name, value}, state) do
    case state.cells[input_cell_name] do
      {:input, cell} -> {:noreply, state, {:continue, {:set_value, cell, value}}}
      _ -> {:noreply, state}
    end
  end

  def handle_cast({:add_callback, compute_cell_name, callback_name, callback}, state) do
    case state.cells[compute_cell_name] do
      {:compute, cell} ->
        {:noreply, state, {:continue, {:add_callback, cell, callback_name, callback}}}

      _ ->
        {:noreply, state}
    end
  end

  def handle_cast({:remove_callback, compute_cell_name, callback_name}, state) do
    case state.cells[compute_cell_name] do
      {:compute, cell} -> {:noreply, state, {:continue, {:remove_callback, cell, callback_name}}}
      _ -> {:noreply, state}
    end
  end

  @impl true
  def handle_continue({:set_value, input_cell, value}, state) do
    :stable = React.InputCell.set_value(input_cell, value)

    for {_name, {:compute, cell}} <- state.cells do
      :resolved = React.ComputeCell.resolve_stable(cell)
    end

    {:noreply, state}
  end

  def handle_continue({:add_callback, compute_cell, callback_name, callback}, state) do
    :added = React.ComputeCell.add_callback(compute_cell, callback_name, callback)
    {:noreply, state}
  end

  def handle_continue({:remove_callback, compute_cell, callback_name}, state) do
    :removed = React.ComputeCell.remove_callback(compute_cell, callback_name)
    {:noreply, state}
  end

  defp start_system(cell_defs) do
    %__MODULE__{cells: Enum.reduce(cell_defs, %{}, &start_cell/2)}
  end

  defp start_cell({:input, cell_name, value}, cells) do
    {:ok, cell_pid} = React.InputCell.start_link(value)

    Map.put(cells, cell_name, {:input, cell_pid})
  end

  defp start_cell({:output, cell_name, input_cell_names, fun}, cells)
       when is_function(fun, length(input_cell_names)) do
    inputs =
      input_cell_names
      |> Enum.map(&cells[&1])
      |> Enum.map(fn
        {:input, cell} -> {cell, React.InputCell.get_value(cell)}
        {:compute, cell} -> {cell, React.ComputeCell.get_value(cell)}
      end)

    {:ok, compute_cell_pid} = React.ComputeCell.start_link(inputs, fun)

    input_cell_names
    |> Enum.map(&cells[&1])
    |> Enum.each(fn
      {:input, cell} -> :registered = React.InputCell.register_child(cell, compute_cell_pid)
      {:compute, cell} -> :registered = React.ComputeCell.register_child(cell, compute_cell_pid)
    end)

    Map.put(cells, cell_name, {:compute, compute_cell_pid})
  end
end

defmodule React.InputCell do
  @moduledoc """
  Functions to create and manipulate input cells in a reactive system.
  """

  use GenServer

  @type t :: %__MODULE__{
          value: React.value(),
          children: list(compute_cell :: pid)
        }

  @enforce_keys ~w[value]a
  defstruct @enforce_keys ++ [children: []]

  # Client

  def start_link(value) do
    GenServer.start_link(__MODULE__, value)
  end

  def get_value(cell) do
    GenServer.call(cell, :get_value)
  end

  def set_value(cell, value) do
    GenServer.call(cell, {:set_value, value})
  end

  def register_child(cell, compute_cell) do
    GenServer.call(cell, {:register_child, compute_cell})
  end

  # Server

  @impl true
  def init(value) do
    {:ok, new(value)}
  end

  @impl true
  def handle_call(:get_value, _from, state) do
    {:reply, state.value, state}
  end

  def handle_call({:set_value, new_value}, _from, state) do
    old_value = state.value
    state = %{state | value: new_value}

    if old_value != new_value do
      myself = self()

      true =
        state.children
        |> Task.async_stream(&React.ComputeCell.update_input(&1, myself, state.value))
        |> Enum.all?(&match?({:ok, :stable}, &1))
    end

    {:reply, :stable, state}
  end

  def handle_call({:register_child, compute_cell}, _from, state) do
    {:reply, :registered, %{state | children: [compute_cell | state.children]}}
  end

  defp new(value) do
    %__MODULE__{value: value}
  end
end

defmodule React.ComputeCell do
  @moduledoc """
  Functions to create and manipulate compute cells in a reactive system.
  """

  use GenServer

  @type t :: %__MODULE__{
          inputs: list({pid, React.value()}),
          fun: (... -> React.value()),
          children: list(compute_cell :: pid),
          callbacks: %{(callback_name :: String.t()) => (React.value() -> any)},
          unstable_value: React.value(),
          value: React.value()
        }

  @enforce_keys ~w[inputs fun unstable_value value]a
  defstruct @enforce_keys ++ [children: [], callbacks: %{}]

  # Client

  def start_link(inputs, fun) do
    GenServer.start_link(__MODULE__, {inputs, fun})
  end

  def get_value(cell) do
    GenServer.call(cell, :get_value)
  end

  def register_child(cell, compute_cell) do
    GenServer.call(cell, {:register_child, compute_cell})
  end

  def add_callback(cell, callback_name, callback_fun) do
    GenServer.call(cell, {:add_callback, callback_name, callback_fun})
  end

  def remove_callback(cell, callback_name) do
    GenServer.call(cell, {:remove_callback, callback_name})
  end

  def update_input(cell, input_cell_pid, value) do
    GenServer.call(cell, {:update_input, input_cell_pid, value})
  end

  def resolve_stable(cell) do
    GenServer.call(cell, :resolve_stable)
  end

  # Server

  @impl true
  def init({inputs, fun}) do
    {:ok, new(inputs, fun)}
  end

  @impl true
  def handle_call(:get_value, _from, state) do
    {:reply, state.value, state}
  end

  def handle_call({:register_child, compute_cell}, _from, state) do
    {:reply, :registered, %{state | children: [compute_cell | state.children]}}
  end

  def handle_call({:add_callback, callback_name, callback_fun}, _from, state) do
    {:reply, :added, %{state | callbacks: Map.put(state.callbacks, callback_name, callback_fun)}}
  end

  def handle_call({:remove_callback, callback_name}, _from, state) do
    {:reply, :removed, %{state | callbacks: Map.delete(state.callbacks, callback_name)}}
  end

  def handle_call({:update_input, input_cell_pid, new_input_value}, _from, state) do
    prev_unstable_value = state.unstable_value

    new_inputs =
      Enum.map(state.inputs, fn
        {^input_cell_pid, _old_value} -> {input_cell_pid, new_input_value}
        other -> other
      end)

    new_unstable_value = apply(state.fun, Enum.map(new_inputs, &elem(&1, 1)))

    new_state = %{state | inputs: new_inputs, unstable_value: new_unstable_value}

    if prev_unstable_value != new_unstable_value do
      myself = self()

      true =
        state.children
        |> Task.async_stream(&React.ComputeCell.update_input(&1, myself, new_unstable_value))
        |> Enum.all?(&match?({:ok, :stable}, &1))
    end

    {:reply, :stable, new_state}
  end

  def handle_call(:resolve_stable, _from, state) do
    if state.value != state.unstable_value do
      {:reply, :resolved, %{state | value: state.unstable_value}, {:continue, :run_callbacks}}
    else
      {:reply, :resolved, state}
    end
  end

  @impl true
  def handle_continue(:run_callbacks, %{value: value} = state) do
    for {name, fun} <- state.callbacks do
      spawn(fn -> fun.(name, value) end)
    end

    {:noreply, state}
  end

  defp new(inputs, fun) do
    value = apply(fun, Enum.map(inputs, &elem(&1, 1)))

    %__MODULE__{
      inputs: inputs,
      fun: fun,
      value: value,
      unstable_value: value
    }
  end
end
