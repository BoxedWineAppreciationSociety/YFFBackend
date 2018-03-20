defmodule YFFBackendWeb.Schema.Query.ArtistsTest do
  use YFFBackendWeb.ConnCase, async: true

  alias YFFBackend.Program

  @artists [
    %{name: "U2"},
    %{name: "Slipknot"},
    %{name: "Taylor Swift"}
  ]

  setup do
    @artists
    |> Enum.each(&Program.create_artist/1)
  end

  @query """
    {
      artists {
        name
      }
    }
  """
  test "artists field returns artists" do
    conn = build_conn()
    conn = post conn, "/graphql", query: @query

    assert json_response(conn, 200) == %{
      "data" => %{
        "artists" => [
          %{"name" => "Slipknot"},
          %{"name" => "Taylor Swift"},
          %{"name" => "U2"}
        ]
      }
    }
  end
end
