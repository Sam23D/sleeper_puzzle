defmodule SleeperPuzzle.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SleeperPuzzleWeb.Telemetry,

      {DNSCluster, query: Application.get_env(:sleeper_puzzle, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: SleeperPuzzle.PubSub},
      {Finch, name: SleeperPuzzle.Finch},
      SleeperPuzzleWeb.Endpoint,

      {Cluster.Supervisor, [lib_cluster_topologies(), [name: SleeperPuzzle.ClusterSupervisor]]},
      SleeperPuzzle.DynamicSupervisor,
      {SleeperPuzzle.Goose.Starter, []}
    ]

    opts = [strategy: :one_for_one, name: SleeperPuzzle.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SleeperPuzzleWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp lib_cluster_topologies,
    do: [
      local: [
        strategy: Cluster.Strategy.Gossip
      ]
    ]
end
