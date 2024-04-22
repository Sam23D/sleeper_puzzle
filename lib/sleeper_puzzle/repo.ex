defmodule SleeperPuzzle.Repo do
  use Ecto.Repo,
    otp_app: :sleeper_puzzle,
    adapter: Ecto.Adapters.Postgres
end
