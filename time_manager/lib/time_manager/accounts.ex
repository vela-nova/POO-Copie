defmodule Timemanager.Accounts do
  import Ecto.Query, warn: false
  alias Timemanager.Repo
  alias Timemanager.Accounts.User

  def list_users(params) do
    query = from(u in User)

    query
    |> filter_by_email(params)
    |> filter_by_username(params)
    |> Repo.all()
  end

  defp filter_by_email(query, %{"email" => email}) when is_binary(email) do
    where(query, [u], u.email == ^email)
  end
  defp filter_by_email(query, _), do: query

  defp filter_by_username(query, %{"username" => username}) when is_binary(username) do
    where(query, [u], u.username == ^username)
  end
  defp filter_by_username(query, _), do: query

  def get_user!(id), do: Repo.get!(User, id)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end
end
