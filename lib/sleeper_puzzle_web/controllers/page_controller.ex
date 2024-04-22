defmodule SleeperPuzzleWeb.PageController do
  use SleeperPuzzleWeb, :controller

  def home(conn, _params) do
    node_type = if (SleeperPuzzle.Goose.where_are_you == node()) do
      :goose
    else
      :duck
    end

    json(conn, %{
      node_name: node(),
      type: node_type
      })
  end
end
