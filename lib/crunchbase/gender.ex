defmodule CrunchBase.Gender do
  @moduledoc ~S"""
  """

  def decode("Male"), do: :male
  def decode("Female"), do: :female
  def decode(_), do: :unknown
end
