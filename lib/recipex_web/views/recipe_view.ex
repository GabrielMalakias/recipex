defmodule RecipexWeb.RecipeView do
  use RecipexWeb, :view

  def markdown_to_html(markdown) do
    Earmark.as_html!(markdown)
  end
end
