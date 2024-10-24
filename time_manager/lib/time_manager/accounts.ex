defmodule Timemanager.Accounts do
  import Ecto.Query, warn: false
  alias Timemanager.Repo
  alias Timemanager.Accounts.User
  alias Timemanager.Accounts.UserToken
  alias Timemanager.Clock

  def list_users do

    subsubq = from c in Clock,
    group_by: c.user_id,
    select: %{maxtime: max(c.time), user_id: c.user_id}

    subq = from c in Clock,
    right_join: subc in subquery(subsubq),
    on: c.user_id == subc.user_id
    and c.time == subc.maxtime,
    select: %{id: c.id, user_id: c.user_id, time: c.time, status: c.status}

    query = from u in User,
    left_join: c in subquery(subq),
    on: u.id == c.user_id,
    order_by: u.id,
    select: %{id: u.id, username: u.username, email: u.email, role: u.role, check_id: c.id, check_time: c.time, check_status: c.status}

    Repo.all(query)
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
    attrs = Map.put_new(attrs, "role", "employee")
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    IO.inspect(attrs, label: "Received attributes for update")
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end
  def update_user_role(%User{} = user, new_role) do
    IO.puts("Updating user role in Accounts module")
    user
    |> User.role_changeset(%{role: new_role})
    |> Repo.update()
  end

  def is_admin?(user) do
    user.role == "admin"
  end

  def create_user_api_token(user) do
    {token, user_token} = UserToken.build_api_token(user)
    Repo.insert!(user_token)
    Base.encode64(token)
  end

  def fetch_user_by_api_token(token) do
    case Base.decode64(token) do
      {:ok, decoded_token} ->
        hashed_token = :crypto.hash(:sha256, decoded_token)
        query = from token in UserToken,
                where: token.token == ^hashed_token,
                join: user in assoc(token, :user),
                select: user

        case Repo.one(query) do
          nil -> {:error, :token_not_found}
          user ->
            IO.puts("Found user with role: #{user.role}")  # Ajoutez cette ligne
            {:ok, user}
        end
      _ ->
        {:error, :invalid_token}
    end
  end

  def revoke_api_token(token) do
    case Base.decode64(token) do
      {:ok, decoded_token} ->
        hashed_token = :crypto.hash(:sha256, decoded_token)
        Repo.delete_all(from t in UserToken, where: t.token == ^hashed_token)
      _ ->
        {:error, :invalid_token}
    end
  end
end
