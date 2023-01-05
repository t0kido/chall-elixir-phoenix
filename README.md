# chall-elixir-phoenix
Elixir/Phoenix Gas Price live view

# To start :
- run docker-compose up -d --build --force-recreate to run Postgres and Adminer
- OR use existing postgres and update connection settings
- mix deps.get
- mix ecto.migrate
- mix tailwind.install
- mix phx.server