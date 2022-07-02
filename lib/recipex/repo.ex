defmodule Recipex.Repo do
  @moduledoc """
  Interfaces with the Registry acting as a repo
  """

  require Logger

  def upsert(%Recipex.Recipe{id: id} = model) do
    Registry.unregister(Recipex.Registry, id)
    Registry.register(Recipex.Registry, id, model)
  end

  def list_all do
    Registry.select(Recipex.Registry, [{{:"$1", :"$2", :"$3"}, [], [:"$3"]}])
  end

  def find(id) do
    case Registry.lookup(Recipex.Registry, id) do
      [{_, head} | _tail] -> head
      _ -> nil
    end
  end
end
