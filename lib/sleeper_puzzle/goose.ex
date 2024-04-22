defmodule SleeperPuzzle.Goose do
  use GenServer

  def init(init_arg) do
    {:ok, init_arg}
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, name: __MODULE__)
  end

  @spec where_are_you() :: atom()
  def where_are_you do
    case Swarm.whereis_name(__MODULE__) do
      goose when is_pid(goose) ->
        node(goose)
      _ -> nil
    end
  end

  def handle_call(:get_node, _from, state) do
    {:reply, node(), state}
  end

  def handle_call({:swarm, :begin_handoff}, _from, state) do
    {:reply, :ignore, state}
  end

  def handle_cast({:swarm, :resolve_conflict, _}, state) do
    {:noreply, state}
  end

  def handle_info({:swarm, :die}, state) do
    {:stop, :shutdown, state}
  end


end
