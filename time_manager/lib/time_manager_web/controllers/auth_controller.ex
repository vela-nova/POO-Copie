defmodule TimemanagerWeb.AuthController do
  use TimemanagerWeb, :controller
  alias Timemanager.Accounts
  alias Timemanager.Accounts.User
  alias Timemanager.Accounts.Auth

  def login(conn, %{"email" => email, "password" => password}) do
    case Auth.authenticate_user(email, password) do  # Utilisez Auth.authenticate_user ici
      {:ok, user} ->
        api_token = Accounts.create_user_api_token(user)
        conn
        |> put_status(:ok)
        |> render(:login, user: user, api_token: api_token)
      {:error, :invalid_credentials} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid credentials"})
    end
  end
  def register(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        api_token = Accounts.create_user_api_token(user)
        conn
        |> put_status(:created)
        |> render(:login, user: user, api_token: api_token)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:error, changeset: changeset)
    end
  end

  def logout(conn, _params) do
    if conn.halted do
      conn
    else
      case get_req_header(conn, "authorization") do
        ["Bearer " <> token] ->
          clean_token = String.trim(token, "\"")
          Accounts.revoke_api_token(clean_token)
        _ -> :ok
      end

      conn
      |> put_status(:ok)
      |> json(%{message: "Logged out successfully"})
    end
  end

  def me(conn, _) do
    user = conn.assigns.current_user
    render(conn, :user, user: user)
  end

  def refresh(conn, _) do
    user = conn.assigns.current_user
    new_api_token = Accounts.create_user_api_token(user)
    render(conn, :token, api_token: new_api_token)
  end

  def change_password(conn, %{"currentPassword" => current_password, "newPassword" => new_password}) do
    user = conn.assigns.current_user

    case Auth.change_user_password(user, current_password, new_password) do
      {:ok, _updated_user} ->
        json(conn, %{message: "Password changed successfully"})
      {:error, :invalid_current_password} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Current password is invalid"})
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:error, changeset: changeset)
    end
  end
  def update_role(conn, %{"user_id" => user_id, "role" => new_role}) do
    current_user = conn.assigns.current_user

    if Accounts.is_admin?(current_user) do
      case Accounts.update_user_role(user_id, new_role) do
        {:ok, updated_user} ->
          json(conn, %{message: "Role updated successfully", user: updated_user})
        {:error, changeset} ->
          errors = Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
            Enum.reduce(opts, msg, fn {key, value}, acc ->
              String.replace(acc, "%{#{key}}", to_string(value))
            end)
          end)
          conn
          |> put_status(:unprocessable_entity)
          |> json(%{errors: errors})
      end
    else
      conn
      |> put_status(:forbidden)
      |> json(%{error: "Only admins can update roles"})
    end
  end
  defp changeset_error_to_string(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Enum.reduce("", fn {k, v}, acc ->
      joined_errors = Enum.join(v, "; ")
      "#{acc}#{k}: #{joined_errors}\n"
    end)
  end

end
