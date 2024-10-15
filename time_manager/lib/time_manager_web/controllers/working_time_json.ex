defmodule TimemanagerWeb.WorkingTimeJSON do
  def index(%{working_times: working_times}) do
    %{data: Enum.map(working_times, &working_time_to_map/1)}
  end

  def show(%{working_time: working_time}) do
    %{data: working_time_to_map(working_time)}
  end

  defp working_time_to_map(working_time) do
    %{
      id: working_time.id,
      start: working_time.start,
      end: working_time.end,
      user_id: working_time.user_id,
      inserted_at: working_time.inserted_at,
      updated_at: working_time.updated_at
    }
  end
end
