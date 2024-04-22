# SleeperPuzzle

This is a solution to the Sleeper Assignment - Duck Duck Goose

The app runs a server on port `localhost:4000` by default and returns a json paylod about the node on `/`

We use `libcluster` and `swarm` for clustering and node registry, a simple GenServer is spined up in only one node, this node runing the Goose process is the Goose Node, if the Goose node goes down and the cluster has the minimum nodes required to reach quorum, a new process will be created on a node in the cluster and that node will become the Goose.

The cluster is configured to run on the same machine, other clustering strategies can be configured to work with DNS, K8s and more...

> We based our start_and_monitor implementation in Starter out of [this blogpost by @bigardone](https://bigardone.dev/blog/2021/06/06/three-real-world-examples-of-distributed-elixir-pt-2)

### Installation
Make sure you have elixir installed

```bash
mix deps.get
mix deps.compile
```

### How to run
In order for the app to select one Goose we need to spin up a *minimum of 3 nodes*.

1. 
```bash
# run the server on different consoles
iex --name node_a -S mix phx.server

PHX_PORT=4001 iex --name node_b -S mix phx.server

PHX_PORT=4002 iex --name node_c -S mix phx.server

PHX_PORT=4003 iex --name node_c -S mix phx.server
```
2. Open a tab for each `localhost:4000`, `localhost:4001`, `localhost:4002`, `localhost:4003`.

3. Close the console of the goose node and refresh the tabs

> we can configure the cluster size and quorum requirements in `dev.exs`:

```elixir
config :swarm,
    ...
    static_quorum_size: 2
```