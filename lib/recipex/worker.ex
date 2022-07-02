defmodule Recipex.Worker do
  @moduledoc """
  Updates the registry with new records when the cache expires
  """

  require Logger
  use GenServer

  def start_link(%{upsert_fun: _up_fn, retrieve_fun: _re_fn} = state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(state) do
    schedule_work()

    {:ok, state}
  end

  @impl true
  def handle_info(:retrieve, %{upsert_fun: upsert_fun, retrieve_fun: retrieve_fun} = state) do
    schedule_work()

    Logger.info "Updating records on registry"
    Enum.each(retrieve_fun.(), fn item ->
      Logger.info "Updating record: #{item.id}"
      upsert_fun.(item)
    end)

    {:noreply, state}
  end


  defp schedule_work do
    Process.send_after(self(), :retrieve, interval())
  end

  defp interval do
    Application.fetch_env!(:recipex, :cache_expiration)
  end
end
