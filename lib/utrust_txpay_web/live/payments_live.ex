defmodule UtrustTxpayWeb.PaymentsLive do
  use UtrustTxpayWeb, :live_view

  alias UtrustTxpay.Payments
  alias UtrustTxpay.Payments.Payment

  alias UtrustTxpayWeb.{FormComponent, PaymentsListComponent}

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Payments.subscribe()

    list_payments = Payments.list_payments()

    changeset = Payments.change_payment(%Payment{})

    socket =
      assign(socket,
        payments: list_payments,
        changeset: changeset
      )

    {:ok, socket, temporary_assigns: [payments: []]}
  end

  @impl true
  def handle_info({:payment_created, payment}, socket) do
    socket =
      update(
        socket,
        :payments,
        fn payments -> [payment | payments] end
      )

    {:noreply, socket}
  end

  @impl true
  def handle_info({:payment_update, payment}, socket) do
    socket =
      update(
        socket,
        :payments,
        fn payments -> [payment | payments] end
      )

    {:noreply, socket}
  end
end
