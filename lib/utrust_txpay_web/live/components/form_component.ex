defmodule UtrustTxpayWeb.FormComponent do
  use UtrustTxpayWeb, :live_component

  alias UtrustTxpay.Payments
  alias UtrustTxpay.Payments.Payment

  @impl true
  def render(assigns) do
    ~L"""
    <div id="new-payment-container">
      <header>
        <h1>Create new payment</h1>
      </header>

      <%= f = form_for @changeset, "#", phx_submit: "create-payment", phx_target: @myself %>
        <div class="field">
          <%= text_input f, :hash, placeholder: "Enter the transaction hash", autocomplete: "off" %>
          <%= error_tag f, :hash %>
        </div>

        <%= submit "Create payment", phx_disable_with: "Saving..." %>
      </form>
    </div>
    """
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
end
