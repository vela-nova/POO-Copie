defmodule TimemanagerWeb.ClockController do
  use TimemanagerWeb, :controller
  alias Timemanager.Clock
  alias Timemanager.Repo
  import Ecto.Query

  action_fallback TimemanagerWeb.FallbackController

  def index(conn, %{"userID" => user_id}) do
    user_id = String.to_integer(user_id)
    clocks = Repo.all(from c in Clock, where: c.user_id == ^user_id)
    IO.inspect(clocks, label: "Horloges récupérées")

  conn
|> render("index.json", clocks: clocks)
  end

  def create(conn, %{"clock" => clock_params, "userID" => user_id}) do
    case Clock.create_clock(user_id, clock_params) do
      {:ok, clock} ->
        conn
        |> put_status(:created)
        |> render("show.json", clock: clock)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: changeset_error_to_string(changeset)})
    end
  end

  defp changeset_error_to_string(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
