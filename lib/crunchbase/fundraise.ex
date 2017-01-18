defmodule CrunchBase.Fundraise do
  @moduledoc ~S"""
  """

  defstruct ~w(id url type series qualifier announced closed raised raised_in_usd target target_in_usd terms investments created_at updated_at)a

  def get(id: id), do: get(CrunchBase.client, id: id)
  def get(client, id: id), do: CrunchBase.Client.get!(client, "/funding-rounds/#{id}") |> decode

  defp decode(%HTTPoison.Response{status_code: 200} = response),
    do: decode(response.body)

  defp decode(response) when is_binary(response),
    do: response |> Poison.decode! |> Map.get("data") |> decode

  defp decode(response) when is_map(response) do
    %CrunchBase.Fundraise{
      id: response["uuid"],
      url: "https://www.crunchbase.com/" <> response["properties"]["web_path"],

      type: type(response),
      series: response["properties"]["series"],
      qualifier: response["properties"]["series_qualifier"],

      announced: CrunchBase.Date.decode(response["properties"]["announced_on"]),
      closed: CrunchBase.Date.decode(response["properties"]["closed_on"]),

      raised: figure(response, "money_raised"),
      raised_in_usd: figure(response, "money_raised_usd"),

      target: figure(response, "target_money_raised"),
      target_in_usd: figure(response, "target_money_raised_usd"),

      terms: terms(response),

      created_at: response["properties"]["created_at"],
      updated_at: response["properties"]["updated_at"]
    }
  end

  defp figure(response, name) when name in ~w(money_raised_usd target_money_raised_usd) do
    CrunchBase.Figure.new(response["properties"][name], "USD")
  end

  defp figure(response, name) do
    CrunchBase.Figure.new(
      response["properties"][name],
      response["properties"][name <> "_currency_code"]
    )
  end

  defp type(response) do
    case response["properties"]["funding_type"] do
      "seed" -> :seed
      "angel" -> :angel
      "venture" -> :venture
      "private_equity" -> :private_equity
      "product_crowdfunding" -> :crowdfunding
      "equity_crowdfunding" -> :crowdfunding
      "grant" -> :grant
      "debt_financing" -> :financing
      "post_ipo_debt" -> :financing
      _ -> :unknown
    end
  end

  defp terms(response) do
    case response["properties"]["funding_type"] do
      "product_crowdfunding" -> :cash
      "equity_crowdfunding" -> :equity
      "grant" -> :cash
      "convertible_note" -> :convertible_note
      "debt_financing" -> :debt
      "post_ipo_debt" -> :debt
      "post_ipo_equity" -> :equity
      _ -> :unknown
    end
  end
end
