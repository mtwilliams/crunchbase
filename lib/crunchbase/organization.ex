defmodule CrunchBase.Organization do
  @moduledoc ~S"""
  """

  defstruct ~w(id slug url logo role name also_known_as ticker founded defunct brief description links created_at updated_at)a

  def get(slug: slug), do: get(CrunchBase.client, slug: slug)
  def get(client, slug: slug), do: CrunchBase.Client.get!(client, "/organizations/#{slug}") |> decode

  defp decode(%HTTPoison.Response{status_code: 200} = response),
    do: decode(response.body)

  defp decode(response) when is_binary(response),
    do: response |> Poison.decode! |> Map.get("data") |> decode

  defp decode(response) when is_map(response) do
    %CrunchBase.Organization{
      id: response["uuid"],
      slug: response["properties"]["permalink"],
      url: "https://www.crunchbase.com/" <> response["properties"]["web_path"],
      logo: response["properties"]["profile_image_url"],
      role: role(response),
      name: response["properties"]["name"],
      also_known_as: response["properties"]["also_known_as"],
      ticker: ticker(response),
      founded: CrunchBase.Date.decode(response["properties"]["founded_on"]),
      defunct: CrunchBase.Date.decode(response["properties"]["closed_on"]),
      brief: response["properties"]["short_description"],
      description: CrunchBase.Text.normalize(response["properties"]["description"]),
      links: CrunchBase.Links.decode(response),
      created_at: response["properties"]["created_at"],
      updated_at: response["properties"]["updated_at"]
    }
  end

  defp role(response) do
    case response["properties"]["primary_role"] do
      "company" -> :company
      "investor" -> :investor
      "school" -> :school
      _ -> :unknown
    end
  end

  defp ticker(response) do
    case {response["properties"]["stock_exchange"], response["properties"]["stock_symbol"]} do
      {nil, nil} -> nil
      {nil, symbol} -> symbol
      {exchange, symbol} -> exchange <> ":" <> symbol
    end
  end
end
