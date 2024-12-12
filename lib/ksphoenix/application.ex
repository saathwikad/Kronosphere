defmodule Ksphoenix.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      KsphoenixWeb.Telemetry,
      # Start the Ecto repository
      Ksphoenix.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Ksphoenix.PubSub},
      # Start Finch
      {Finch, name: Ksphoenix.Finch},
      # Start the Endpoint (http/https)
      KsphoenixWeb.Endpoint
      # Start a worker by calling: Ksphoenix.Worker.start_link(arg)
      # {Ksphoenix.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ksphoenix.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    KsphoenixWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
