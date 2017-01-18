defmodule CrunchBase.Person do
  @moduledoc ~S"""
  """

  defstruct ~w(id slug url portrait name gender birth death biography links created_at updated_at)a

  def get(slug: slug), do: get(CrunchBase.client, slug: slug)
  def get(client, slug: slug), do: CrunchBase.Client.get!(client, "/people/#{slug}") |> decode

  defp decode(%HTTPoison.Response{status_code: 200} = response),
    do: decode(response.body)

  defp decode(response) when is_binary(response),
    do: response |> Poison.decode! |> Map.get("data") |> decode

  defp decode(response) when is_map(response) do
    %CrunchBase.Person{
      id: response["uuid"],
      slug: response["properties"]["permalink"],
      url: "https://www.crunchbase.com/" <> response["properties"]["web_path"],
      portrait: response["properties"]["profile_image_url"],
      name: response["properties"]["first_name"] <> " " <> response["properties"]["last_name"],
      gender: CrunchBase.Gender.decode(response["properties"]["gender"]),
      birth: CrunchBase.Date.decode(response["properties"]["born_on"]),
      death: CrunchBase.Date.decode(response["properties"]["died_on"]),
      biography: CrunchBase.Text.normalize(response["properties"]["bio"]),
      links: CrunchBase.Links.decode(response),
      created_at: response["properties"]["created_at"],
      updated_at: response["properties"]["updated_at"]
    }
  end
end
