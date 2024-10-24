defmodule Timemanager.Accounts.Auth do
  alias Timemanager.Accounts.User
  alias Timemanager.Repo

  def authenticate_user(email, password) do
    user = Repo.get_by(User, email: email)
    case user do
      nil -> {:error, :invalid_credentials}
      user ->
        if Bcrypt.verify_pass(password, user.password_hash) do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end

  def change_user_password(user, current_password, new_password) do
    if Bcrypt.verify_pass(current_password, user.password_hash) do
      User.password_changeset(user, %{password: new_password})
      |> Repo.update()
    else
      {:error, :invalid_current_password}
    end
  end
end
