defmodule Recipex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      RecipexWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Recipex.PubSub},
      # Start the Endpoint (http/https)
      RecipexWeb.Endpoint
      # Start a worker by calling: Recipex.Worker.start_link(arg)
      # {Recipex.Worker, arg}
    ] ++ custom_workers(Mix.env)

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Recipex.Supervisor]
    app = Supervisor.start_link(children, opts)

    initialize_registry(Process.whereis(Recipex.Worker))

    app
  end

  def initialize_registry(nil), do: nil
  def initialize_registry(pid), do: Process.send_after(pid, :retrieve, 0)

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RecipexWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  def custom_workers(:test), do: []

  def custom_workers(_env) do
    [
      {Registry, keys: :unique, name: Recipex.Registry},
      {Recipex.Worker, %{upsert_fun: &Recipex.Repo.upsert/1, retrieve_fun: &Recipex.Client.list_recipes/0}}
    ]
  end
end
