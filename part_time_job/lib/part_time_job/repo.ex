defmodule PartTimeJob.Repo do
  use Ecto.Repo,
    otp_app: :part_time_job,
    adapter: Ecto.Adapters.Postgres
end
