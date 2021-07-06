defmodule UtrustTxpay.Etherscan.Formatter do
  alias Decimal, as: D

  def format_block_confirmation(value),
    do: value |> String.split() |> Enum.at(0) |> String.to_integer()

  def format_currency(value),
    do: value |> String.split() |> Enum.at(0) |> D.new()

  def format_timestamp(value) do
    Regex.run(~r"\(([^\)]+)\)", value)
    |> Enum.at(-1)
    |> String.split()
    |> Enum.take(2)
    |> Enum.join(" ")
  end
end
