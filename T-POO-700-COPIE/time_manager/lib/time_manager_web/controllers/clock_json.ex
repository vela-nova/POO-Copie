defmodule TimemanagerWeb.ClockJSON do
  def index(%{clocks: clocks}) do
    %{data: Enum.map(clocks, &clock_to_map/1)}
  end

  def show(%{clock: clock}) do
    %{data: clock_to_map(clock)}
  end

  defp clock_to_map(clock) do
    %{
      id: clock.id,
      time: clock.time,
      status: clock.status,
      user_id: clock.user_id,
      inserted_at: clock.inserted_at,
      updated_at: clock.updated_at
    }
  end
end
