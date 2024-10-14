defmodule Timemanager.Clock do
  use Ecto.Schema
  import Ecto.Changeset
  alias Timemanager.Repo
  alias Timemanager.Clock.ClockSchema

  schema "clocks" do
    field :time, :naive_datetime
    field :status, :boolean
    belongs_to :user, Timemanager.User

    timestamps()
  end

  def changeset(clock, attrs) do
    clock
    |> cast(attrs, [:time, :status, :user_id])
    |> validate_required([:time, :status, :user_id])
    |> foreign_key_constraint(:user_id, message: "User must exist")
  end

  def create_clock(user_id, clock_params) do
    %__MODULE__{}
    |> changeset(prepare_clock_params(user_id, clock_params))
    |> Repo.insert()
  end

  defp prepare_clock_params(user_id, clock_params) do
    clock_params
    |> Map.put("user_id", user_id)
    |> Map.put("time", NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second))
  end
end
