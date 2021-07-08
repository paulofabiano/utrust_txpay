defmodule UtrustTxpay.Payments.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  alias UtrustTxpay.Schema.PaymentStatusEnum

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @fields [
    :hash,
    :status,
    :block_confirmations,
    :timestamp,
    :value,
    :fee
  ]

  @required_fields [:hash]

  schema "payments" do
    field :hash, :string
    field :status, PaymentStatusEnum, default: "pending"
    field :block_confirmations, :string
    field :timestamp, :string
    field :value, :string
    field :fee, :string

    timestamps()
  end

  def changeset(payment, params) do
    payment
    |> cast(params, @fields)
    |> validate_required(@required_fields)
    |> unique_constraint([:hash])
  end
end
