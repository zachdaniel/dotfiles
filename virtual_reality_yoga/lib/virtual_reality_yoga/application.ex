defmodule VirtualRealityYoga.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      VirtualRealityYogaWeb.Telemetry,
      VirtualRealityYoga.Repo,
      {DNSCluster,
       query: Application.get_env(:virtual_reality_yoga, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: VirtualRealityYoga.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: VirtualRealityYoga.Finch},
      # Start a worker by calling: VirtualRealityYoga.Worker.start_link(arg)
      # {VirtualRealityYoga.Worker, arg},
      # Start to serve requests, typically the last entry
      VirtualRealityYogaWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: VirtualRealityYoga.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    VirtualRealityYogaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
