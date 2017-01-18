defmodule CrunchBase.Links do
  @moduledoc ~S"""
  """

  defstruct ~w(website blog angellist facebook linkedin twitter instagram google_plus youtube tumblr quora github)a

  require Logger
  alias Logger, as: L

  @type_to_field %{
    "homepage" => :website,
    "angellist" => :angellist,
    "facebook" => :facebook,
    "linkedin" => :linkedin,
    "twitter" => :twitter,
    "instagram" => :instagram,
    "google+" => :google_plus,
    "youtube" => :youtube,
    "tumblr" => :tumblr,
    "quora" => :quora,
    "github" => :github
  }

  def decode(response) do
    if relationships = response["relationships"] do
      websites = relationships["websites"]["items"]

      links =
        Enum.reduce(websites, %{}, fn (item, links) ->
          type = item["properties"]["website_type"]
          case Map.fetch(@type_to_field, type) do
            {:ok, link} ->
              Map.put(links, link, item["properties"]["url"])
            _ ->
              L.warn "Unknown type of link `#{type}`!"
              links
          end
        end)

      struct(__MODULE__, links)
    else
      %__MODULE__{
        website: response["properties"]["homepage_url"],
        blog: response["properties"]["blog_url"],
        angellist: response["properties"]["angellist_url"],
        facebook: response["properties"]["facebook_url"],
        linkedin: response["properties"]["linkedin_url"],
        twitter: response["properties"]["twitter_url"],
        instagram: response["properties"]["instagram_url"],
        google_plus: response["properties"]["google+_url"],
        youtube: response["properties"]["youtube_url"],
        tumblr: response["properties"]["tumblr_url"],
        quora: response["properties"]["quora_url"],
        github: response["properties"]["github_url"]
      }
    end
  end
end
