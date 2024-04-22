defmodule SleeperPuzzle.Goose.Starter do

  use GenServer
  require Logger

  alias SleeperPuzzle.DynamicSupervisor
  alias SleeperPuzzle.Goose

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl GenServer
  def init(opts) do
    {:ok, opts, {:continue, {:start_and_monitor, 1}}}
  end

  @impl GenServer
  def handle_continue({:start_and_monitor, retry}, opts) do
    case Swarm.whereis_or_register_name(
            Goose,
           DynamicSupervisor,
           :start_child,
           [opts]
         ) do
      {:ok, pid} ->
        Process.monitor(pid)
        {:noreply, {pid, opts}}

      other ->
        IO.puts("error while fetching or registering process: #{inspect(other)}")
        {:noreply, opts, {:continue, {:start_and_monitor, retry + 1}}}
    end
  end

  @impl GenServer
  def handle_info({:DOWN, _, :process, pid, _reason}, {pid, opts}) do
    {:noreply, opts, {:continue, {:start_and_monitor, 1}}}
  end

end
