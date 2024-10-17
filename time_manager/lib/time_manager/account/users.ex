defmodule Timemanager.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:username, :string)
    field(:email, :string)
    has_many(:clocks, Timemanager.Clock)
    has_many(:working_time, Timemanager.WorkingTime)

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email])
    |> validate_required([:username, :email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+\.[^\s]+$/)
    |> unique_constraint(:username)
    |> unique_constraint(:email)
  end
end
