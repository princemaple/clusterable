# Clusterable

Help cluster Elixir nodes, ideal for using with `iex` and `mix`,
not suitable for using with releases.

With `Clusterable`, you can forget about special settings/configurations
for clustering. And you no longer need to start Elixir/Erlang with `--sname`
or `--name`.

## Not for releases

It's mainly for docker users (like me), and those who don't use releases.
It won't work in releases, as `:net_kernel` will already be started, and the cookie will already be set.

## What is it good for?

It's good for clusters that don't have a fixed number of nodes,
and you don't want to manage an orchestration script/tool that assigns names/IPs
before nodes boot. i.e. it's for auto scaling clusters and lazy devs :+1:

## Installation

It's [available in Hex](https://hex.pm/packages/clusterable), the package can be
installed by adding `clusterable` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:clusterable, "~> 0.2"}]
end
```

## Example Config

```elixir
config :clusterable,
  cookie: :my_cookie,
  app_name: "my_app"
```

## Example Usage

Start Elixir with `--erl` or `ELIXIR_ERL_OPTIONS`:

```
-proto_dist Elixir.Clusterable.EPMD.Service
-epmd_module Elixir.Clusterable.EPMD.Client"
```

e.g. `iex --erl "--proto_dist ... -epmd_module ..." -S mix`

Add Clusterable to a supervision tree as a non-permanent worker,
i.e. `transient` or `temporary`

```elixir
worker(Clusterable, [], restart: :transient)
```

For Elixir 1.5+, simply add `Clusterable` to your children list,
its child_spec sets the correct restart strategy already.

If you are playing with it in IEx, you can start it manually

```elixir
Clusterable.start_link
```

## Testing with Docker 1.10+

- clone Clusterable project
- in the project dir, run the commands below:

```
docker build -t clusterable .
docker network create -d bridge peer

# open shell 1
docker run --rm -it --network peer --network-alias peer clusterable
iex> Clusterable.start_link

# open shell 2, do the same
docker run --rm -it --network test --network-alias peer clusterable
iex> Clusterable.start_link
```
