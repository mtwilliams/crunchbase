defmodule CrunchBase.Text do
  @moduledoc ~S"""
  """

  def normalize(text) do
    text |> String.replace("\r\n", "\n")
  end
end
