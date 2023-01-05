defmodule Http.WrapperTest do
  use ExUnit.Case, async: true
  alias Chall.APIResponse
  alias Http.{Wrapper, Mock}
  import Mox

  setup :verify_on_exit!

  test "should pass a proper arguments" do
    url = "url"

    expect(Mock, :get, fn ^url ->
      {:ok, %HTTPoison.Response{status_code: 200, body: "{}"}}
    end)

    Wrapper.get(url)
  end

  test "should return a custom error" do
    # given
    error = {:error, :nxdomain}

    # when
    expect(Mock, :get, fn _ -> error end)

    # then
    assert ^error = Wrapper.get("url")
  end

  test "should return simple HTTPoison.Error" do
    # given
    reason = "reason"
    error = {:error, %HTTPoison.Error{reason: reason}}

    expect(Mock, :get, fn _ -> error end)

    assert {:error, ^reason} = Wrapper.get("url")
  end

  test "should return complex HTTPoison.Error" do
    # given
    reason = "reason"
    error = {:error, %HTTPoison.Error{reason: {:error, reason}}}

    # when
    expect(Mock, :get, fn _ -> error end)

    # then
    assert {:error, ^reason} = Wrapper.get("url")
  end

  test "should return 200 response" do
    # given
    body = "{}"
    res = {:ok, %HTTPoison.Response{status_code: 200, body: body}}

    # when
    expect(Mock, :get, fn _ -> res end)

    # then
    assert {
             :ok,
             %APIResponse{}
           } = Wrapper.get("url")
  end
end
