defmodule WorkingTimeGenerator do
  alias Timemanager.WorkingTime

  def generate_monthly_working_times(user_id, min_hours, max_hours) do
    current_year = Date.utc_today().year

    Enum.each(1..12, fn month ->
      work_days = Enum.random(15..22)

      Enum.each(1..work_days, fn day ->
        hours_worked = :rand.uniform() * (max_hours - min_hours) + min_hours

        start_time = generate_start_time(current_year, month, day)
        end_time = NaiveDateTime.add(start_time, trunc(hours_worked * 3600), :second)

        attrs = %{
          "start" => start_time,
          "end" => end_time
        }

        case WorkingTime.create_working_time(user_id, attrs) do
          {:ok, _working_time} -> IO.puts("Created working time for #{start_time}")
          {:error, changeset} -> IO.puts("Error creating working time: #{inspect(changeset.errors)}")
        end
      end)
    end)
  end

  defp generate_start_time(year, month, day) do
    hour = Enum.random(8..16)
    minute = Enum.random(0..59)

    {:ok, date} = Date.new(year, month, day)
    {:ok, time} = Time.new(hour, minute, 0)

    NaiveDateTime.new!(date, time)
  end
end

user_id = 6
min_hours = 6
max_hours = 9

WorkingTimeGenerator.generate_monthly_working_times(user_id, min_hours, max_hours)
