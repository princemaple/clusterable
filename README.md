# Clusterable

`Clusterable` prepares a node to be clustered.

With `Clusterable`, you can forget about special settings/configurations
for clustering. And you no longer need to start Elixir/Erlang with `--sname`
or `--name`.

If you use `Clusterable` and `Peerage` together, clustering just becomes
so easy and happens like magic!

*Not tested with `libcluster` but should work too*

## Not for releases

This does not work for releases. It's mainly for docker users (like me), and those who don't use releases.

It won't work in releases, as `:net_kernel` will already be started, and the cookie will already be set.

## What is it good for?

It's good for clusters that don't have a fixed number of nodes, and you don't want to manage an orchestration
script/tool that assigns names/IPs before nodes boot. For example, auto scaling cluster, and lazy devs :+1:

## Installation

It's [available in Hex](https://hex.pm/packages/clusterable), the package can be
installed by adding `clusterable` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:clusterable, "~> 0.1"}]
end
```

It's tested with [Peerage](https://github.com/mrluc/peerage), if you want to use
it with `Peerage`:

```elixir
def deps do
  [{:clusterable, "~> 0.1"},
   {:peerage, "~> 1.0"}]
end
```

It should work with [libcluster](https://github.com/bitwalker/libcluster) as well

```elixir
def deps do
  [{:clusterable, "~> 0.1"},
   {:libcluster, "~> 2.0"}]
end
```

## Example Config with Peerage

If using peerage dns, make sure the two `app_name`
configs are the same.

```elixir
config :clusterable,
  cookie: :cluster,
  app_name: "elixir"

config :peerage, # if using DNS
  via: Peerage.Via.Dns,
  dns_name: "peer",
  app_name: "elixir"

config :peerage, # if using UDP
  via: Peerage.Via.Udp,
  serves: true,
  port: 45900
```

## Example Usage

Add Clusterable to a supervision tree as a non-permanent worker,
i.e. `transient` or `temporary`

```elixir
worker(Clusterable, [], restart: :transient)
```

If you are playing with it in IEx, you can start it manually

```elixir
Clusterable.start_link
```

## Testing with Docker 1.10+

- clone Clusterable project
- uncomment according configs in `config/config.exs`
- remove `optional: true` in `mix.exs` for `:peerage`
- in the project dir, run the commands below:

```
docker build -t clusterable .
docker network create -d bridge peer

# open shell 1
docker run --rm -it --network test --network-alias peer clusterable
iex> Clusterable.start_link

# open shell 2, do the same
docker run --rm -it --network test --network-alias peer clusterable
iex> Clusterable.start_link
```
