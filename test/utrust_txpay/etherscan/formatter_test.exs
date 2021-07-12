defmodule UtrustTxpay.Etherscan.FormatterTest do
  use UtrustTxpay.DataCase

  alias UtrustTxpay.Payments
  alias UtrustTxpay.Etherscan.Formatter

  alias Decimal, as: D

  describe "formatters" do
    @valid_attrs %{
      hash: "0x0223216562b3adfa579011832818237de81e80a5e8620e08674282e315a55ee1"
    }

    def payment_fixture(attrs \\ %{}) do
      {:ok, payment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Payments.create_payment()

      payment
    end

    test "format_block_confirmation/1 returns integer amount" do
      amount = 34

      value =
        "#{amount} blocks confirmations"
        |> Formatter.format_block_confirmation()

      assert value == amount
    end

    test "format_currency/1 returns value as Decimal" do
      amount = "0.98839"

      value =
        "#{amount} Ether ($2,105.21)"
        |> Formatter.format_currency()

      assert value == D.new(amount)
    end

    test "format_timestamp/1 returns formatted datetime" do
      datetime = "Jul-09-2021 08:32:40"

      value =
        "27 secs ago (#{datetime} PM +UTC)"
        |> Formatter.format_timestamp()

      assert value == datetime
    end
  end
end
