defmodule SleeperPuzzle.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SleeperPuzzleWeb.Telemetry,
      SleeperPuzzle.Repo,
      {DNSCluster, query: Application.get_env(:sleeper_puzzle, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: SleeperPuzzle.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: SleeperPuzzle.Finch},
      # Start a worker by calling: SleeperPuzzle.Worker.start_link(arg)
      # {SleeperPuzzle.Worker, arg},
      # Start to serve requests, typically the last entry
      SleeperPuzzleWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
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
end
