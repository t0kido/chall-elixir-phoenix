defmodule Chall.Repo.Migrations.CreateGasStations do
  use Ecto.Migration

  def change do
    create table(:gas_stations, primary_key: false) do
      add :recordid, :string, primary_key: true
      add :prix_valeur, :float
      add :name, :string, size: 500
      add :adresse, :string, size: 1000
      add :prix_nom, :string, primary_key: true
      # timestamps
    end

    create constraint(:gas_stations, "price_must_be_positive",
             check: "prix_valeur > 0",
             comment: "Verify price before saving data"
           )

    create unique_index(:gas_stations, [:recordid, :prix_nom], name: :unique_recordid_for_type)
  end
end
