defmodule PartTimeJob.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PartTimeJobWeb.Telemetry,
      PartTimeJob.Repo,
      {DNSCluster, query: Application.get_env(:part_time_job, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PartTimeJob.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PartTimeJob.Finch},
      # Start a worker by calling: PartTimeJob.Worker.start_link(arg)
      # {PartTimeJob.Worker, arg},
      # Start to serve requests, typically the last entry
      PartTimeJobWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PartTimeJob.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PartTimeJobWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
