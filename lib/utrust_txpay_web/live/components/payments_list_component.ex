defmodule UtrustTxpayWeb.PaymentsListComponent do
  use UtrustTxpayWeb, :live_component

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
              <%= if payment.id == @checking do %>
                <div>Confirmations: Checking...</div>
              <% else %>
                <div>Confirmations: <%= if payment.block_confirmations, do: payment.block_confirmations, else: "N/A" %></div>
              <% end %>
              <%= if payment.status == :pending do %>
                <div><button phx-click="verify-payment" phx-value-id="<%= payment.id %>" phx-disable-with="Checking...">Check</button></div>
              <% end %>
            </li>
          <% end %>
        </ul>
      <% end %>
    </div>
    """
  end
end
