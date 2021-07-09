defmodule UtrustTxpayWeb.FormComponent do
  use UtrustTxpayWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div id="new-payment-container" class="flex w-full flex-col">
      <header class="mb-2">
        <h1 class="text-xl text-purple-600">Create new payment</h1>
      </header>

      <%= f = form_for @changeset, "#", phx_submit: "create-payment", class: "flex flex-row border border-gray-300 rounded-lg p-4" %>
        <div class="flex flex-grow">
          <%= text_input f, :hash, placeholder: "Enter the transaction hash", autocomplete: "off", class: "flex-grow focus:outline-none text-sm" %>
          <%= error_tag f, :hash %>
        </div>

        <%= submit "Create payment", phx_disable_with: "Saving...", class: "flex-none rounded-md bg-purple-600 text-white text-xs py-2 px-3" %>
      </form>
    </div>
    """
  end
end
