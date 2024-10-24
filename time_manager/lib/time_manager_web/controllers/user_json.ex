# lib/time_manager_web/controllers/user_json.ex
defmodule TimemanagerWeb.UserJSON do
  alias Timemanager.Accounts.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
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




  defp data(%{id: id, username: username, email: email, role: role, check_id: check_id, check_time: check_time, check_status: check_status}) do
    %{
      id: id,
      username: username,
      email: email,
      role: role,
      check_id: check_id,
      check_time: check_time,
      check_status: check_status
    }
  end
end
