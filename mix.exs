defmodule BX.Mixfile do
  use Mix.Project

  def project do
    [app: :befungex,
     version: "0.0.1",
     elixir: "~> 1.0",
     escript: [main_module: BX],
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be HBX packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more BXamples and options
  defp deps do
    []
  end
end
