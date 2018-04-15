defmodule YFFBackendWeb.Resolvers.Program do
  def artists(_, %{filter: _} = filters, _) do
    {:ok, YFFBackend.Program.list_artists(filters)}
  end

  def artists(_, args, _), do: {:ok, YFFBackend.Program.list_artists(args) }

  def get_artist(_, %{id: id}, _), do: {:ok, YFFBackend.Program.get_artist!(id)}

  def artist_for_performance(performance,_,_), do: {:ok, YFFBackend.Program.get_artist!(performance.artist_id)}

  def performances(_, %{day: day}, _), do: {:ok, YFFBackend.Program.list_performances(day) }
  def performances(_, _, _), do: {:ok, YFFBackend.Program.list_performances() }

  @timezone "Australia/Melbourne"
  def day_for_performance(%{time:  time} = performance, _, _) do
    with %DateTime{} = local_time <- Timex.to_datetime(time, @timezone),
         day_int <- Timex.weekday(local_time),
         weekday <- day_for_weekday(day_int)
    do
      {:ok, weekday}
    end
  end

  # The festival at the moment is only over the three days
  def day_for_weekday(5), do: :friday
  def day_for_weekday(6), do: :saturday
  def day_for_weekday(7), do: :sunday
end
