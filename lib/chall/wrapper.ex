defmodule Http.Wrapper do
  alias Chall.APIResponse
  alias Chall.Parameters
  alias Chall.Records
  alias Chall.Fields
  @http_adapter Application.compile_env(:chall, :http_client)

  def get(url) do
    url
    |> get_url()
    |> process_response_body(url)
  end

  defp get_url(url),
    do: @http_adapter.get(url)

  defp process_response_body(
         {:ok, %HTTPoison.Response{status_code: status_code, body: body}},
         _url
       )
       when status_code in [200, 201, 204],
       do: {:ok, parse_body(body)}

  defp process_response_body(
         {:ok, %HTTPoison.Response{status_code: status_code, body: body, headers: _headers}},
         url
       ) do
    {
      :error,
      %{
        status_code: status_code,
        body: parse_body(body),
        url: url
      }
    }
  end

  defp process_response_body({:error, %HTTPoison.Error{reason: {_, reason}}}, _url),
    do: {:error, reason}

  defp process_response_body({:error, %HTTPoison.Error{reason: reason}}, _url),
    do: {:error, reason}

  defp process_response_body({:error, reason}, _url),
    do: {:error, reason}

  defp parse_body(body) do
    body
    |> Poison.decode!(%{
      as: %APIResponse{parameters: %Parameters{}, records: [%Records{fields: %Fields{}}]}
    })
  end
end
