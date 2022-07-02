defmodule Recipex.Mapper do
  @moduledoc """
  Converts a json into a model, the model in this case is %Recipex.Recipe
  """

  def transform(parsed_json) do
    parsed_json
    |> Map.get("items")
    |> Enum.map(fn item -> transform(item, parsed_json) end)
  end

  defp transform(node, fulljson) do
    %Recipex.Recipe{
      id: node["sys"]["id"],
      tags: Enum.map(node["fields"]["tags"] || [], fn item -> find_resource("tags", item, fulljson["includes"]["Entry"]) end),
      title: node["fields"]["title"],
      image: find_resource("photo", node["fields"]["photo"], fulljson["includes"]["Asset"]),
      chef_name: find_resource("chef", node["fields"]["chef"], fulljson["includes"]["Entry"]),
      description: node["fields"]["description"]
    }
  end

  defp find_resource(_, nil, _), do: nil
  defp find_resource("chef", %{"sys" => %{"id" => id}}, json) do
    Enum.find(json, fn x -> x["sys"]["id"] == id end)["fields"]["name"]
  end
  defp find_resource("tags", %{"sys" => %{"id" => id}}, json) do
    Enum.find(json, fn x -> x["sys"]["id"] == id end)["fields"]["name"]
  end
  defp find_resource("photo", %{"sys" => %{"id" => id}}, json) do
    Enum.find(json, fn x -> x["sys"]["id"] == id end)["fields"]["file"]["url"]
  end
end
