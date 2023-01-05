defmodule Chall.APIDataWorker do
  use GenServer
  alias Http.Wrapper
  alias Chall.{GasStation, Repo}

  # Pre-filter data for Île de france only (reg_code = 11)
  @url "https://data.economie.gouv.fr/api/records/1.0/search/?dataset=prix-carburants-fichier-instantane-test-ods-copie&lang=en&sort=prix_valeur&facet=prix_maj&rows=5000&start=0&refine.reg_code=11"

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(state) do
    schedule_gas_price_fetch()
    {:ok, state}
  end

  @impl true
  def handle_info(:gas_price_fetch, state) do
    get_api_datas()
    {:noreply, state}
  end

  defp get_api_datas() do
    {:ok, response} = Wrapper.get(@url)

    Repo.insert_all(
      GasStation,
      response
      |> Map.get(:records)
      |> map_records(),
      on_conflict: {:replace, [:prix_valeur, :name, :adresse, :prix_nom]},
      conflict_target: [:recordid, :prix_nom]
    )
  end

  defp schedule_gas_price_fetch() do
    Process.send_after(self(), :gas_price_fetch, 1_000)
  end

  defp map_records(records) do
    # convert api response records to a map, insert_all only supports map (schemaless query)
    # https://github.com/elixir-ecto/ecto/issues/1167
    Enum.filter(records, fn record -> !is_nil(record.fields.prix_valeur) end)
    |> Enum.map(fn record ->
      %{
        recordid: record.recordid,
        prix_valeur: record.fields.prix_valeur,
        adresse: "#{record.fields.adresse} - #{record.fields.cp} #{record.fields.com_name}",
        # api does not return name, only address
        name: record.fields.adresse,
        prix_nom: record.fields.prix_nom
      }
    end)
  end
end
