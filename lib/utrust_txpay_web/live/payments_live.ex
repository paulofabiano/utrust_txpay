defmodule UtrustTxpayWeb.PaymentsLive do
  use UtrustTxpayWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, payments: [])}
  end
end
