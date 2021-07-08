defmodule UtrustTxpayWeb.PaymentsLive do
  use UtrustTxpayWeb, :live_view

  alias UtrustTxpay.Payments
  alias UtrustTxpay.Payments.Payment
  alias UtrustTxpay.Etherscan.{Scraper, Transaction}

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
  def handle_event("create-payment", %{"payment" => params}, socket) do
    case Payments.create_payment(params) do
      {:ok, payment} ->
        socket =
          update(
            socket,
            :payments,
            fn payments -> [payment | payments] end
          )

        changeset = Payments.change_payment(%Payment{})

        socket = assign(socket, changeset: changeset)

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket = assign(socket, changeset: changeset)

        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("verify-payment", %{"id" => id}, socket) do
    :timer.sleep(500)

    case Payments.get_payment!(id) do
      %Payment{} = payment ->
        case Scraper.get_transaction(payment.hash) do
          %Transaction{} = transaction ->
            update_payment_status(payment, transaction.block_confirmations)
        end
    end

    {:noreply, socket}
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

  defp update_payment_status(payment, block_confirmations) when block_confirmations >= 2 do
    Payments.update_payment(payment, %{
      status: "confirmed",
      block_confirmations: Integer.to_string(block_confirmations)
    })
  end

  defp update_payment_status(payment, block_confirmations) do
    Payments.update_payment(payment, %{
      block_confirmations: Integer.to_string(block_confirmations)
    })
  end
end
