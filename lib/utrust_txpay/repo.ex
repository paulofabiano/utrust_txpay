defmodule UtrustTxpay.Repo do
  use Ecto.Repo,
    otp_app: :utrust_txpay,
    adapter: Ecto.Adapters.Postgres
end
