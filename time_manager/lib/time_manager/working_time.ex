defmodule Timemanager.WorkingTime do
  use Ecto.Schema
  import Ecto.Changeset
  alias Timemanager.Repo

  schema "working_time" do
    field(:start, :naive_datetime)
    field(:end, :naive_datetime)
    belongs_to(:user, Timemanager.User)

    timestamps()
  end

  def changeset(clock, attrs) do
    clock
    |> cast(attrs, [:start, :end, :user_id])
    |> validate_required([:start, :end, :user_id])
    |> foreign_key_constraint(:user_id, message: "User must exist")
  end

  def create_working_time(user_id, attrs) do
    %Timemanager.WorkingTime{}
    |> changeset(Map.put(attrs, "user_id", user_id))
    |> Repo.insert()
  end
end
