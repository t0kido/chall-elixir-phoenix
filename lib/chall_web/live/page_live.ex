defmodule ChallWeb.PageLive do
  import Ecto.Query, only: :macros
  use Phoenix.LiveView
  alias Chall.{Repo, GasStation}

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, 0)
    {:ok, assign(socket, exp_stations: [], cheap_stations: [])}
  end

  @impl true
  def handle_info(:update, socket) do
    Process.send_after(self(), :update, 10_000)

    {:noreply,
     assign(socket, exp_stations: get_stations(:desc), cheap_stations: get_stations(:asc))}
  end

  @impl true
  def render(assigns) do
    ChallWeb.PageView.render("index.html", assigns)
  end

  defguard is_asc(sort) when sort == :asc

  defp get_stations(sort) when not is_asc(sort) do
    Repo.all(from s in GasStation, order_by: [desc: s.prix_valeur], limit: 10)
  end

  defp get_stations(_sort) do
    Repo.all(from s in GasStation, order_by: [asc: s.prix_valeur], limit: 10)
  end
end
