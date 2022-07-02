defmodule Recipex.RepoTest do
  use ExUnit.Case, async: false

  setup do
    _ = start_supervised!({Registry, name: Recipex.Registry, keys: :unique})
    %{registry: Recipex.Registry}
  end

  test 'upsert/1 when the record does not exist it creates it' do
    record = %Recipex.Recipe{
      id: 123,
      title: "Super mega title"
    }

    assert Recipex.Repo.list_all == []

    Recipex.Repo.upsert(record)

    assert length(Recipex.Repo.list_all) == 1
  end

  test 'upsert/1 when the record exists it updates it' do
    record = %Recipex.Recipe{
      id: 123,
      title: "Super mega title"
    }

    Recipex.Repo.upsert(record)

    Recipex.Repo.upsert(%{record | title: "Ultra title"})

    assert Recipex.Repo.find(123).title == "Ultra title"
  end

  test "list_all/0 returns all the records" do
    record_1 = %Recipex.Recipe{
      id: 123,
      title: "Super mega title"
    }
    record_2 = %Recipex.Recipe{
      id: 124,
      title: "Title"
    }

    Recipex.Repo.upsert(record_1)
    Recipex.Repo.upsert(record_2)

    assert Recipex.Repo.list_all == [
      record_2, record_1
    ]
  end

  test "find/1 returns the record when it exists" do
    record = %Recipex.Recipe{
      id: 123,
      title: "Super mega title"
    }

    Recipex.Repo.upsert(record)

    assert Recipex.Repo.find(123) == record
  end

  test "find/1 returns nil when it doesnt exist" do
    assert Recipex.Repo.find(123) == nil
  end
end

