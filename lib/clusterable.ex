defmodule Clusterable do
  @moduledoc """
  ## Example Config

      config :clusterable,
        cookie: :my_cookie,
        app_name: "my_app"

  ## Example Usage

  Add Clusterable to a supervision tree as a non-permanent worker,
  i.e. `transient` or `temporary`

      worker(Clusterable, [], restart: :transient)

  For Elixir 1.5+, simply add `Clusterable` to your children list,
  its child_spec sets the correct restart strategy already.

  If you are playing with it in IEx, you can start it manually

      Clusterable.start_link
  """

  use GenServer, restart: :transient

  @doc """
  Call this to prepare the node for clustering
  """
  def start_link do
    {:ok, _apps} = Application.ensure_all_started(:libcluster)
    GenServer.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    send self(), :enable
    {:ok, nil}
  end

  def handle_info(:enable, _) do
    {:ok, ip_groups} = :inet.getif

    ip =
      ip_groups
      |> Enum.reject(fn
        {{127, 0, 0, 1}, _, _} -> true
        _ -> false
      end)
      |> Enum.map(fn {{a, b, c, d}, _, _} -> [a, b, c, d] end)
      |> List.first
      |> Enum.map(&to_string/1)
      |> Enum.join(".")

    sname = Application.fetch_env!(:clusterable, :app_name)

    {:ok, pid} = :net_kernel.start([:"#{sname}@#{ip}"])
    Node.set_cookie(Application.fetch_env!(:clusterable, :cookie))

    {:stop, :normal, pid}
  end
end
