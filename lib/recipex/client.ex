defmodule Recipex.Client do
  @moduledoc """
  Executes a request to the contentful page to retrieve the recipe entries and
  uses the mapper to return a model
  """

  def list_recipes do
    build_url("/entries?sys.contentType.sys.id=recipe")
    |> HTTPoison.get!
    |> transform
  end

  def build_url(resource) do
    "https://cdn.contentful.com/spaces/#{space_id()}#{resource}&access_token=#{access_token()}"
  end

  defp transform(%HTTPoison.Response{body: body, status_code: 200}) do
    body
    |> Jason.decode!
    |> Recipex.Mapper.transform
  end

  defp space_id, do: config(:space_id)

  defp access_token, do: config(:access_token)

  defp config(attribute) do
    Keyword.get(Application.fetch_env!(:recipex, :contentful), attribute)
  end
end
