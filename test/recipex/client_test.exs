defmodule Recipex.ClientTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  test 'build/1 builds the url correctly' do
    resource = "/entries?sys.contentType.sys.id=recipe"

    assert Recipex.Client.build_url(resource) ==
    "https://cdn.contentful.com/spaces/space_id/entries?sys.contentType.sys.id=recipe&access_token=access_token"
  end

  test 'list_recipes retrieves the resources correctly' do
    use_cassette "list_recipes" do
      [first | _tail] = Recipex.Client.list_recipes

      assert first == %Recipex.Recipe{chef_name: nil, description: "*Grilled Cheese 101*: Use delicious cheese and good quality bread; make crunchy on the outside and ooey gooey on the inside; add one or two ingredients for a flavor punch! In this case, cherry preserves serve as a sweet contrast to cheddar cheese, and basil adds a light, refreshing note. Use __mayonnaise__ on the outside of the bread to achieve the ultimate, crispy, golden-brown __grilled cheese__. Cook, relax, and enjoy!", id: "4dT8tcb6ukGSIg2YyuGEOm", image: "//images.ctfassets.net/kk2bw5ojx476/61XHcqOBFYAYCGsKugoMYK/0009ec560684b37f7f7abadd66680179/SKU1240_hero-374f8cece3c71f5fcdc939039e00fb96.jpg", tags: ["vegan"], title: "White Cheddar Grilled Cheese with Cherry Preserves & Basil"}
    end
  end
end
