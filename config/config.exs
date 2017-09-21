use Mix.Config

config :clusterable,
  cookie: :cluster,
  app_name: "elixir"

config :libcluster,
  topologies: [
    clusterable: [strategy: Cluster.Strategy.Gossip]
  ]
