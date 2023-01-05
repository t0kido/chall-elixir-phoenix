defmodule ChallWeb.PageLiveTest do
  use ChallWeb.ConnCase
  import Phoenix.LiveViewTest
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
    adresse: "add 2",
    name: "gas station 2",
    prix_nom: "SP95"
  }

  setup [:create_gas_stations]

  test "can visit home page", %{conn: conn} do
    {:ok, view, html} = live(conn, "/")

    assert html =~ "Gas Price"

    assert render(view) =~ "Gas Price"
  end

  test "verify data from database are rendered on the view", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    send(view.pid, :update)
    rendered_view = render(view)

    # verify all values are rendered 
    assert rendered_view =~ @gas_station1.name
    assert rendered_view =~ @gas_station2.name
  end

  defp create_gas_stations(_) do
    assert {2, nil} =
             Repo.insert_all(
               GasStation,
               [@gas_station1, @gas_station2]
             )

    :ok
  end
end
