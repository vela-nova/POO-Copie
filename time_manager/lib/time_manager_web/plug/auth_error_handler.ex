defmodule TimemanagerWeb.AuthErrorHandler do
  import Plug.Conn

  def auth_error(conn, {type, reason}, _opts) do
    IO.puts("Auth Error: #{type}, Reason: #{inspect(reason)}")
    body = Jason.encode!(%{error: to_string(type)})
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, body)
  end
end
