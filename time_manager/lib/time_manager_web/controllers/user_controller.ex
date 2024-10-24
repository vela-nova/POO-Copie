defmodule TimemanagerWeb.UserController do
  use TimemanagerWeb, :controller

  alias Timemanager.Accounts
  alias Timemanager.Accounts.User

  action_fallback TimemanagerWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", ~p"/api/users/#{user}")
        |> render(:show, user: user)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:error, changeset: changeset)
    end
  end

  def show(conn, %{"userID" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  def update(conn, %{"userID" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)
    user_params = Map.delete(user_params, "role")
    case Accounts.update_user(user, user_params) do
      {:ok, updated_user} ->
        render(conn, :show, user: updated_user)
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:error, changeset: changeset)
    end
  end

  def update_role(conn, %{"userID" => id, "role" => new_role}) do
    IO.puts("Attempting to update role for user #{id} to #{new_role}")
    user = Accounts.get_user!(id)
    case Accounts.update_user_role(user, new_role) do
      {:ok, updated_user} ->
        IO.puts("Successfully updated user role")
        render(conn, :show, user: updated_user)
      {:error, %Ecto.Changeset{} = changeset} ->
        IO.puts("Failed to update user role")
        IO.inspect(changeset.errors, label: "Changeset errors")
        conn
        |> put_status(:unprocessable_entity)
        |> render(:error, changeset: changeset)
    end
  end
  def delete(conn, %{"userID" => id}) do
    user = Accounts.get_user!(id)

    case Accounts.delete_user(user) do
      {:ok, _deleted_user} ->
        send_resp(conn, :no_content, "")
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:error, changeset: changeset)
    end
  end
end
