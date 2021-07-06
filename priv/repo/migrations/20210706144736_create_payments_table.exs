defmodule UtrustTxpay.Repo.Migrations.CreatePaymentsTable do
  use Ecto.Migration

  alias UtrustTxPay.Schema.PaymentStatusEnum

  def change do
    PaymentStatusEnum.create_type()

    create table(:payments) do
      add :hash, :string
      add :status, PaymentStatusEnum.type(), default: "pending", null: false
      add :block_confirmations, :string
      add :timestamp, :string
      add :value, :string
      add :fee, :string

      timestamps()
    end

    create(unique_index(:payments, [:hash]))
  end
end
