defmodule Resnet.MixProject do
  use Mix.Project

  def project do
    [
      app: :resnet,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {ResnetApplication, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:faas_base, "~> 1.1.1"},
      {:bumblebee, "~> 0.4"},
      {:stb_image, "~> 0.6"},
      {:exla, "~> 0.6"}
    ]
  end
end
