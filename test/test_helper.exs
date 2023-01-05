ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Chall.Repo, :manual)

Mox.defmock(
  Http.Mock,
  for: Http.Behaviour
)
