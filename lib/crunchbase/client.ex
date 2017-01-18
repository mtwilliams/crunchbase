defmodule CrunchBase.Client do
  @moduledoc ~S"""
  """

  defstruct ~w(api_key options)a

  @doc ~S"""
  """
  def new(options \\ []) do
    fields = Enum.map(~w(api_key)a, fn field ->
      value = Keyword.get(options, field, Application.get_env(:crunchbase, field))
      {field, value}
    end)

    default_options = CrunchBase.defaults |> Map.new
    options = Keyword.take(options, CrunchBase.options) |> Enum.into(default_options)

    struct(__MODULE__, Enum.into(fields, %{options: options}))
  end

  defp headers(client) do
    %{"User-Agent"    => client.options[:user_agent],
      "Content-Type"  => "application/json"}
  end

  defp parameters(client) do
    %{"user_key" => client.api_key}
  end

  def get(client, path, params \\ %{}) do
    params_with_auth = Map.merge(params, parameters(client))
    HTTPoison.get(client.options[:base_url] <> path, headers(client), params: params_with_auth)
  end

  def get!(client, path, params \\ %{}) do
    params_with_auth = Map.merge(params, parameters(client))
    HTTPoison.get!(client.options[:base_url] <> path, headers(client), params: params_with_auth)
  end
end
