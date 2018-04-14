defmodule YFFBackendWeb.Resolvers.Program do
  def artists(_, %{filter: _} = filters, _) do
    {:ok, YFFBackend.Program.list_artists(filters)}
  end

  def artists(_, args, _), do: {:ok, YFFBackend.Program.list_artists(args) }

  def get_artist(_, %{id: id}, _), do: {:ok, YFFBackend.Program.get_artist!(id)}

  def artist_for_performance(performance,_,_), do: {:ok, YFFBackend.Program.get_artist!(performance.artist_id)}

  def performances(_, _, _), do: {:ok, YFFBackend.Program.list_performances() }
end
