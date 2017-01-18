defmodule CrunchBase.Figure do
  @moduledoc ~S"""
  """

  def new(nil, _currency), do: nil
  def new(amount, currency), do: {Decimal.new(amount), currency}

  def amount({amount, _currency} = _figure), do: amount
  def currency({_amount, currency} = _figure), do: currency
end
