defmodule Recipex.WorkerTest do
  use ExUnit.Case, async: true

  test "records are inserted when the retrieve is called" do
    pid = self()

    dummy_upsert = fn _ ->
      send(pid, :inserted)
    end

    dummy_retrieve = fn ->
      [%Recipex.Recipe{id: 123, title: "Testing"}, %Recipex.Recipe{id: 124, title: "Testing2"}]
    end

    {:ok, worker} = Recipex.Worker.start_link(%{upsert_fun: dummy_upsert, retrieve_fun: dummy_retrieve})

    send(worker, :retrieve)

    assert_receive(:inserted, 100)
    assert_receive(:inserted, 100)
  end
end
