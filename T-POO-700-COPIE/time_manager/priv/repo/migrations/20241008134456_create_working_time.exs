defmodule Timemanager.Repo.Migrations.CreateWorkingTime do
  use Ecto.Migration

  def change do
    create table(:working_time) do
      add(:start, :naive_datetime, null: false)
      add(:end, :naive_datetime, null: false)
      add(:user_id, references(:users, on_delete: :delete_all), null: false)

      timestamps()
    end

    create(index(:working_time, [:user_id]))
  end
end
