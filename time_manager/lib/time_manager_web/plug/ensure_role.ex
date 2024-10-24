defmodule TimemanagerWeb.EnsureRole do
  import Plug.Conn
  import Phoenix.Controller

  def init(roles) when is_list(roles), do: Enum.map(roles, &to_string/1)
  def init(role) when is_atom(role), do: [to_string(role)]

  def call(conn, roles) do
    user = conn.assigns[:current_user]
    IO.puts("EnsureRole: User role is #{user.role}, Required roles are #{inspect(roles)}")

    if user && (user.role in roles) do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> json(%{error: "Access forbidden"})
      |> halt()
    end
  end
end
