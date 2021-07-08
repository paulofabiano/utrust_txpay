defmodule UtrustTxpayWeb.PaymentsListComponent do
  use UtrustTxpayWeb, :live_component

  alias UtrustTxpay.Payments
  alias UtrustTxpay.Payments.Payment
  alias UtrustTxpay.Etherscan.{Scraper, Transaction}

  @impl true
  def render(assigns) do
    ~L"""
    <div id="payments-container">
      <header>
        <h1>List of payments</h1>
      </header>

      <%= if Enum.empty?(@payments) do %>
        <p>No payment was found.</p>
      <% else %>
        <ul id="payments-list" phx-update="prepend">
          <%= for payment <- @payments do %>
            <li id="<%= payment.id %>">
              <%= payment.hash %>
              <div>Status: <%= payment.status %></div>
              <div>Confirmations: <%= if payment.block_confirmations, do: payment.block_confirmations, else: "--" %></div>
              <%= if payment.status == :pending do %>
                <div><button phx-click="verify-payment" phx-value-id="<%= payment.id %>" phx-disable-with="Checking..." phx-target="<%= @myself %>">Check</button></div>
              <% end %>
            </li>
          <% end %>
        </ul>
      <% end %>
    </div>
    """
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
