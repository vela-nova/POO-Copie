defmodule TimemanagerWeb.WorkingTimeController do
  use TimemanagerWeb, :controller
  alias Timemanager.WorkingTime
  alias Timemanager.Repo
  import Ecto.Query

  action_fallback(TimemanagerWeb.FallbackController)

  def index(conn, %{"userID" => user_id, "start" => startTime, "end" => endTime}) do
    user_id = String.to_integer(user_id)

    query =
      from(wt in WorkingTime,
        where: wt.user_id == ^user_id and wt.start < ^endTime and wt.end > ^startTime
      )

    working_times = Repo.all(query)

    render(conn, TimemanagerWeb.WorkingTimeJSON, "index.json", working_times: working_times)
  end

  def show(conn, %{"userID" => user_id, "id" => wt_id}) do
    user_id = String.to_integer(user_id)
    wt_id = String.to_integer(wt_id)

    query =
      from(wt in WorkingTime,
        where: wt.user_id == ^user_id and wt.id == ^wt_id
      )

    working_times = Repo.all(query)

    render(conn, TimemanagerWeb.WorkingTimeJSON, "index.json", working_times: working_times)
  end

  def create(conn, %{"working_time" => wt_params, "userID" => user_id}) do
    case WorkingTime.create_working_time(user_id, wt_params) do
      {:ok, wt} ->
        conn
        |> put_status(:created)
        |> render(TimemanagerWeb.WorkingTimeJSON, "show.json", working_time: wt)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: changeset.errors})
    end
  end

  def update(conn, %{"working_time" => wt_params, "id" => wt_id}) do
    wt_id = String.to_integer(wt_id)

    query =
      from(wt in WorkingTime,
        where: wt.id == ^wt_id,
        select: %{
          id: wt.id,
          start: wt.start,
          end: wt.end,
          user_id: wt.user_id,
          inserted_at: wt.inserted_at,
          updated_at: wt.updated_at
        }
      )

    wt_keyword_list =
      Enum.map(wt_params, fn {key, value} -> {String.to_existing_atom(key), value} end)

    updated_wt = Repo.update_all(query, set: wt_keyword_list)

    updated_wt = updated_wt |> elem(1)

    updated_wt = List.pop_at(updated_wt, 0) |> elem(0)

    render(conn, TimemanagerWeb.WorkingTimeJSON, "show.json", working_time: updated_wt)
  end
end
