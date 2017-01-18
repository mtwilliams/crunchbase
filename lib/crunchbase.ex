defmodule CrunchBase do
  @moduledoc ~S"""
  """

  @options ~w(user_agent base_url proxy timeout)a

  @defaults [{:user_agent, "Elixir/#{System.version()}"},
             {:base_url, "https://api.crunchbase.com/v/3"},
             {:proxy, nil},
             {:timeout, 5000}]

  for {name, default} <- @defaults do
    def unquote(:"default_#{name}")(), do: unquote(default)
    def unquote(name)(), do: Application.get_env(:crunchbase, unquote(name), unquote(default))
  end

  @doc ~S"""
  """
  def defaults do
    Enum.map(@options, fn option ->
      {option, apply(CrunchBase, option, [])}
    end)
  end

  @doc ~S"""
  """
  def options, do: @options

  @doc ~S"""
  """
  def client(options \\ []), do: CrunchBase.Client.new(options)
end
