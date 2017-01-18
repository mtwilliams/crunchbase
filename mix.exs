defmodule CrunchBase.Mixfile do
  use Mix.Project

  def project do
    [name: "CrunchBase",
     app: :crunchbase,
     version: version(),
     description: "CrunchBase for Alchemists.",
     homepage_url: homepage_url(),
     source_url: github_url(),
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     build_path: "_build",
     deps_path: "_deps",
     deps: deps(),
     package: package(),
     docs: docs(),
     test_coverage: [tool: ExCoveralls]]
  end

  def application do
    [applications: applications(Mix.env)]
  end

  defp applications(_), do: ~w()a ++ applications()
  defp applications, do: ~w(logger httpoison)a

  defp homepage_url, do: github_url()
  defp github_url, do: "https://github.com/meetwalter/crunchbase"
  defp documentation_url, do: "https://github.com/meetwalter/crunchbase"

  defp version, do: "0.0.0"

  defp elixirc_paths(:test), do: ~w(test) ++ elixirc_paths()
  defp elixirc_paths(_), do: elixirc_paths()
  defp elixirc_paths, do: ~w(lib)

  defp deps do [
    {:httpoison, ">= 0.0.0"},
    {:poison, ">= 1.0.0"},

    # Testing
    {:excoveralls, "~> 0.4", only: :test},

    # Documentation
    {:ex_doc, ">= 0.0.0", only: [:dev, :docs]},
    {:earmark, ">= 0.0.0", only: [:dev, :docs]},
    {:inch_ex, ">= 0.0.0", only: [:dev, :docs]}
  ] end

  defp package do
    [maintainers: ["Michael Williams"],
     licenses: ["Public Domain"],
     links: %{"GitHub" => github_url(), "Docs" => documentation_url()},
     files: ~w(mix.exs lib README* LICENSE*)]
  end

  defp docs do
    [main: "CrunchBase",
     canonical: "http://hexdocs.pm/crunchbase",
     source_ref: version(),
     source_url: github_url()]
  end
end
