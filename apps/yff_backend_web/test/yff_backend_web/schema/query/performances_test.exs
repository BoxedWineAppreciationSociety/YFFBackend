defmodule YFFBackendWeb.Schema.Query.PerformancesTest do
  use YFFBackendWeb.ConnCase, async: true

  alias YFFBackend.Program

  @artists [
    %{name: "U2"},
    %{name: "Slipknot"},
    %{name: "Taylor Swift"}
  ]

  @performances

  setup do
    @artists
    |> Enum.each(&Program.create_artist/1)
  end
end
