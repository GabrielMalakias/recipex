defmodule Recipex.RegistryTest do
  use ExUnit.Case, async: false

  setup do
    _ = start_supervised!({Registry, name: Recipex.Registry, keys: :unique})
    %{registry: Recipex.Registry}
  end

  test 'values are available after the registration' do
    assert Registry.values(Recipex.Registry, :alive, self()) == []

    {:ok, _} = Registry.register(Recipex.Registry, :alive, :true)

    assert Registry.values(Recipex.Registry, :alive, self()) == [:true]
  end
end
