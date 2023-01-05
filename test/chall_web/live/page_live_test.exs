defmodule ChallWeb.PageLiveTest do
  use ChallWeb.ConnCase, async: false

  import Phoenix.LiveViewTest
  import Ecto.Query, only: [from: 2]

  alias Chall.{GasStation, Repo}

  @gas_station1 %{
    recordid: "record1",
    prix_valeur: 1.12,
    adresse: "add 1",
    name: "gas station 1",
    prix_nom: "SP95"
  }

  @gas_station2 %{
    recordid: "record2",
    prix_valeur: 1.90,
    adresse: "add 1",
    name: "gas station 2",
    prix_nom: "SP95"
  }

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  setup [:create_gas_stations]

  test "can visit home page", %{conn: conn} do
    {:ok, view, html} = live(conn, "/")

    assert html =~ "Gas Price"

    assert render(view) =~ "Gas Price"
  end

  defp create_gas_stations(_) do
    gas_stations = [@gas_station1, @gas_station2]

    Repo.insert_all(
      GasStation,
      gas_stations
    )

    :ok
  end
end
