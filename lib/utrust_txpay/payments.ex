defmodule UtrustTxpay.Payments do
  import Ecto.Query, warn: false

  alias UtrustTxpay.Repo
  alias UtrustTxpay.Payments.Payment

  def subscribe do
    Phoenix.PubSub.subscribe(UtrustTxpay.PubSub, "payments")
  end

  def get_payment!(id), do: Repo.get!(Payment, id)

  def list_payments do
    Repo.all(from p in Payment, order_by: [desc: p.inserted_at])
  end

  def create_payment(attrs \\ %{}) do
    %Payment{}
    |> Payment.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:payment_created)
  end

  def update_payment(%Payment{} = payment, attrs) do
    payment
    |> Payment.changeset(attrs)
    |> Repo.update()
    |> broadcast(:payment_update)
  end

  def broadcast({:ok, payment}, event) do
    Phoenix.PubSub.broadcast(
      UtrustTxpay.PubSub,
      "payments",
      {event, payment}
    )

    {:ok, payment}
  end

  def broadcast({:error, _reason} = error, _event), do: error

  def change_payment(%Payment{} = payment, attrs \\ %{}) do
    Payment.changeset(payment, attrs)
  end

  def delete_payment(%Payment{} = payment) do
    Repo.delete(payment)
  end
end
