defmodule UtrustTxpay.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  alias UtrustTxPay.Schema.PaymentStatusEnum

  @primary_key {:id, :binary_id, autogenerate: true}

  @fields [
    :hash,
    :status,
    :block_confirmations,
    :timestamp,
    :value,
    :fee
  ]

  schema "payments" do
    field :hash, :string
    field :status, PaymentStatusEnum
    field :block_confirmations, :string
    field :timestamp, :string
    field :value, :string
    field :fee, :string

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> unique_constraint([:hash])
  end
end
