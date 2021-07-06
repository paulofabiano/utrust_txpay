defmodule UtrustTxpay.Payments.Create do
  alias UtrustTxpay.{Payment, Repo}

  def call(params) do
    params
    |> Payment.changeset()
    |> Repo.insert()
  end
end
