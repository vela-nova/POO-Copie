defmodule TimemanagerWeb.AuthJSON do
  alias Timemanager.Accounts.User

  def login(%{user: user, api_token: api_token}) do
    %{
      user: data(user),
      api_token: api_token
    }
  end


  def token(%{api_token: api_token}) do
    %{api_token: api_token}
  end

  def user(%{user: user}) do
    %{data: data(user)}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      email: user.email,
      username: user.username,
      role: user.role
    }
  end


  def error(%{changeset: changeset}) do
    %{errors: Ecto.Changeset.traverse_errors(changeset, &translate_error/1)}
  end

  defp translate_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", fn _ -> to_string(value) end)
    end)
  end
end
