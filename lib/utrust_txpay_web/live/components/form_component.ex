defmodule UtrustTxpayWeb.FormComponent do
  use UtrustTxpayWeb, :live_component

  alias UtrustTxpay.Payments
  alias UtrustTxpay.Payments.Payment

  @impl true
  def render(assigns) do
    ~L"""
    <div id="new-payment-container">
      <header>
        <h1 class="p4">Create new payment</h1>
      </header>

      <%= f = form_for @changeset, "#", phx_submit: "create-payment" %>
        <div class="field">
          <%= text_input f, :hash, placeholder: "Enter the transaction hash", autocomplete: "off" %>
          <%= error_tag f, :hash %>
        </div>

        <%= submit "Create payment", phx_disable_with: "Saving..." %>
      </form>
    </div>
    """
  end
end
