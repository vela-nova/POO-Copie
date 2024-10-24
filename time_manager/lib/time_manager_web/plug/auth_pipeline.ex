defmodule TimemanagerWeb.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :time_manager,
    module: Timemanager.Guardian,
    error_handler: TimemanagerWeb.AuthErrorHandler

  plug :log_request
  plug Guardian.Plug.VerifyHeader, scheme: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource

  def log_request(conn, _opts) do
    IO.puts("Received token: #{get_req_header(conn, "authorization")}")
    conn
  end
end
