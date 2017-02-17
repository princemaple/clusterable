defmodule Clusterable do
  @moduledoc """
  ## Example Config with Peerage

  If using peerage dns, make sure the two `app_name`
  configs are the same.

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

  ## Example Usage

  Add Clusterable to a supervision tree as a transient worker

      worker(Clusterable, [], restart: :transient)

  If you are playing with it in IEx, you can start it manually

      Clusterable.start_link

  ## Testing with Docker

  Clone Clusterable project, in the project dir:

      docker build -t clusterable .
      docker network create test -d bridge

      # open shell 1
      docker run --rm -it --network test --network-alias peer clusterable
      iex> Clusterable.start_link

      # open shell 2, do the same
      docker run --rm -it --network test --network-alias peer clusterable
      iex> Clusterable.start_link
  """

  use GenServer

  @doc """
  Call this to prepare the node for clustering
  """
  def start_link do
    GenServer.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    send self(), :enable
    {:ok, nil}
  end

  def handle_info(:enable, _) do
    {"", 0} = System.cmd("epmd", ["-daemon"])

    {:ok, ip_groups} = :inet.getif

    ip =
      ip_groups
      |> Enum.reject(fn
        {{127, 0, 0, 1}, _, _} -> true
        _ -> false
      end)
      |> Enum.map(fn {{a, b, c, d}, _, _} -> [a, b, c, d] end)
      |> hd()
      |> Enum.map(&to_string/1)
      |> Enum.join(".")

    sname = Application.fetch_env!(:clusterable, :app_name)

    {:ok, pid} = :net_kernel.start([:"#{sname}@#{ip}"])
    Node.set_cookie(Application.fetch_env!(:clusterable, :cookie))

    {:stop, :normal, pid}
  end
end
