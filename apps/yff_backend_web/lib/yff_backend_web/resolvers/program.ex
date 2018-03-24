defmodule YFFBackendWeb.Resolvers.Program do
  def artists(_, %{filter: _} = filters, _) do
    {:ok, YFFBackend.Program.list_artists(filters)}
  end

  def artists(_, _, _), do: {:ok, YFFBackend.Program.list_artists() }
end
