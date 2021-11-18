defmodule Base45Ex.MixProject do
  use Mix.Project

  def project do
    [
      app: :base45_ex,
      version: "0.1.0",
      elixir: "~> 1.13-rc",
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.5", only: [:dev, :test], override: true},
      {:credo_naming, "~> 0.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      # Test coverage
      {:excoveralls, "~> 0.13", only: :test}
    ]
  end
end
