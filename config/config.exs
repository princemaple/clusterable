use Mix.Config

config :clusterable,
  cookie: :cluster,
  app_name: "elixir"

# config :peerage, # if using DNS
#   via: Peerage.Via.Dns,
#   dns_name: "peer",
#   app_name: "elixir"

# config :peerage, # if using UDP
#   via: Peerage.Via.Udp,
#   serves: true,
#   port: 45900
