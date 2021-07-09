defmodule UtrustTxpay.Etherscan.Scraper do
  alias UtrustTxpay.Etherscan.Formatter
  alias UtrustTxpay.Etherscan.Transaction

  @tx_url "https://etherscan.io/tx"

  def get_etherscan_link(hash), do: "#{@tx_url}/#{hash}"

  def get_transaction(tx) do
    headers = [
      {"user-agent",
       "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"},
      {"referer", "https://www.google.com/"}
    ]

    case(HTTPoison.get(get_etherscan_link(tx), headers)) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        parse_and_find_nodes(body)

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp parse_and_find_nodes(body) do
    case Floki.parse_document(body) do
      {:ok, parsed_body} ->
        parsed_body
        |> Floki.find(".card-body div.row")
        |> build_transaction()
    end
  end

  defp build_transaction(nodes) do
    %Transaction{
      hash: extract_node(nodes, "Transaction Hash"),
      status:
        extract_node(nodes, "Status")
        |> String.downcase()
        |> String.to_atom(),
      block_confirmations:
        extract_node(nodes, "Block")
        |> Formatter.format_block_confirmation(),
      timestamp:
        extract_node(nodes, "Timestamp")
        |> Formatter.format_timestamp(),
      value:
        extract_node(nodes, "Value")
        |> Formatter.format_currency(),
      fee:
        extract_node(nodes, "Transaction Fee")
        |> Formatter.format_currency()
    }
  end

  defp extract_node(nodes, data) do
    selected_node =
      nodes
      |> Enum.filter(fn node ->
        case Floki.find(node, "div > div:fl-contains('#{data}')") do
          [] -> false
          _ -> true
        end
      end)

    case selected_node do
      [] ->
        {:error, :not_found}

      [{_element, _attrs, children}] ->
        children
        |> Enum.take(2)
        |> extract_value()
    end
  end

  defp extract_value(node) do
    node
    |> select_correct_data_level()
    |> Floki.text()
  end

  defp select_correct_data_level(node) do
    case Floki.find(node, "i.fa-clock") do
      [] -> Floki.find(node, "span")
      _ -> node
    end
  end
end
