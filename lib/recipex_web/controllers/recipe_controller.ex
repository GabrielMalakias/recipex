defmodule RecipexWeb.RecipeController do
  use RecipexWeb, :controller
  require Logger

  def index(conn, _params) do
    render(conn, "index.html", recipes: Recipex.Repo.list_all)
  end

  def show(conn, %{"id" => id}) do
    render(conn, "show.html", recipe: Recipex.Repo.find(id))
  end
end
