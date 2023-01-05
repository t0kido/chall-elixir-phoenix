defmodule Http.Behaviour do
  @typep url :: binary()
  @typep body :: {:form, [{atom(), any()}]}
  @typep headers :: [{atom, binary}] | [{binary, binary}] | %{binary => binary}
  @typep options :: Keyword.t()

  @callback get(url) :: {:ok, map()} | {:error, binary() | map()}
end
