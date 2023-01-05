defmodule Chall.GasStation do
  use Ecto.Schema

  # Queryable
  @primary_key false
  schema "gas_stations" do
    field :recordid, :string, primary_key: true
    field :prix_valeur, :float
    field :name, :string
    field :adresse, :string
    field :prix_nom, :string, primary_key: true
    # timestamps
  end
end
