defmodule Recipex.Recipe do
  @moduledoc """
  Represents the model for recipes
  """
  defstruct [:id, :title, :image, :tags, :description, :chef_name]
end
