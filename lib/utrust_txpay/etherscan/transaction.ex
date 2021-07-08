defmodule UtrustTxpay.Etherscan.Transaction do
  @enforce_keys [
    :hash,
    :status,
    :block_confirmations,
    :timestamp,
    :value,
    :fee
  ]

  defstruct [
    :hash,
    :status,
    :block_confirmations,
    :timestamp,
    :value,
    :fee
  ]
end
