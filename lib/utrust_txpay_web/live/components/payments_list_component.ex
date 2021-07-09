defmodule UtrustTxpayWeb.PaymentsListComponent do
  use UtrustTxpayWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div id="payments-container" class="flex w-full flex-col">
      <header class="mb-2">
        <h1 class="text-xl text-purple-600">List of payments</h1>
      </header>

      <%= if Enum.empty?(@payments) do %>
        <p>No payment was found.</p>
      <% else %>
        <ul id="payments-list" phx-update="prepend" class="space-y-4">
          <%= for payment <- @payments do %>
            <li id="<%= payment.id %>" class="flex flex-row border border-gray-300 rounded-lg flex-col">
              <div class="p-4 border-b border-gray-300 flex flex-row">
                <div class="flex flex-row flex-grow items-center">
                  <div class="rounded-full w-3 h-3 mr-2 <%= if payment.status == :pending, do: 'bg-yellow-300', else: 'bg-green-300' %>"></div>
                  <div class="text-sm text-gray-700"><%= payment.hash %></div>
                </div>
                <div class="flex-none">
                  <%= link to: UtrustTxpay.Etherscan.Scraper.get_etherscan_link(payment.hash), method: :get, target: "_blank" do %>
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-purple-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
                    </svg>
                  <% end %>
                </div>
              </div>
              <div class="p-4 flex flex-row items-center">
                <div class="flex flex-grow">
                  <%= if payment.id == @checking do %>
                    <div class="text-sm text-gray-700">Confirmations: Checking...</div>
                  <% else %>
                    <div class="text-sm text-gray-700">Confirmations: <%= if payment.block_confirmations, do: payment.block_confirmations, else: "N/A" %></div>
                  <% end %>
                  <span class="px-4 text-sm text-gray-700">|</span>
                  <div class="text-sm text-gray-700">Status: <%= payment.status %></div>
                </div>
                <%= if payment.status == :pending do %>
                  <button phx-click="verify-payment" phx-value-id="<%= payment.id %>" phx-disable-with="Checking..." class="bg-gray-200 text-xs px-2 py-1 flex-none">
                    Verify transaction again
                  </button>
                <% else %>
                  <button phx-click="delete-payment">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-red-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                    </svg>
                  </button>
                <% end %>
              </div>
            </li>
          <% end %>
        </ul>
      <% end %>
    </div>
    """
  end
end
