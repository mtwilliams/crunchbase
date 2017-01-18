defmodule CrunchBase.Date do
  @moduledoc ~S"""
  """

  def decode(date) when is_binary(date) do
    {:ok, decoded} = Date.from_iso8601(date)
    decoded
  end

  def decode(_), do: nil
end
