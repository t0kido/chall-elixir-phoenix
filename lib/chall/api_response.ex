defmodule Chall.APIResponse do
  # @enforce_keys [:nhits]  
  @derive [Poison.Encoder]
  defstruct [
    :nhits,
    :parameters,
    records: []
  ]
end

defmodule Chall.Parameters do
  @derive [Poison.Encoder]
  defstruct [:dataset]
end

defmodule Chall.Records do
  @derive [Poison.Encoder]
  defstruct [:recordid, :datasetid, :fields]
end

defmodule Chall.Fields do
  @derive [Poison.Encoder]
  defstruct [
    :ville,
    :pop,
    :reg_name,
    :dep_name,
    :prix_nom,
    :prix_valeur,
    :adresse,
    :cp,
    :com_name
  ]
end
