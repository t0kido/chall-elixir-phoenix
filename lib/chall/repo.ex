defmodule Chall.Repo do
  use Ecto.Repo,
    otp_app: :chall,
    adapter: Ecto.Adapters.Postgres
end
