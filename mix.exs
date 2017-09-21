defmodule Clusterable.Mixfile do
  use Mix.Project

  def project do
    [app: :clusterable,
     version: "0.2.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     package: package()]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [{:libcluster, "~> 2.0", runtime: false},
     {:ex_doc, ">= 0.0.0", only: :dev}]
  end

  defp package do
    [description: "Clusterable makes clustering easier",
     licenses: ["MIT"],
     maintainers: ["Po Chen"],
     links: %{"GitHub": "https://github.com/princemaple/clusterable"}]
  end
end
