defmodule UtrustTxpay.PaymentsLiveTest do
  use UtrustTxpayWeb.ConnCase

  import Phoenix.LiveViewTest

  test "user can create a payment", %{conn: conn} do
    hash = "0x0223216562b3adfa579011832818237de81e80a5e8620e08674282e315a55ee1"

    {:ok, view, _html} = live(conn, Routes.payments_path(conn, :index))

    assert view
           |> form("#new-payment-form", payment: %{hash: hash})
           |> render_submit() =~ hash
  end

  test "user can't create a payment without a hash", %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.payments_path(conn, :index))

    assert view
           |> form("#new-payment-form", payment: %{hash: ""})
           |> render_submit() =~ "can&#39;t be blank"
  end
end
