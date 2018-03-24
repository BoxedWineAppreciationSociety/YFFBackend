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

  @query """
    query($filter: ArtistFilter!) {
      artists(filter: $filter) {
        name
      }
    }
  """
  @variables %{filter: %{matching: "Slip"}}
  test "artists filtered by matching name" do
    response = get(build_conn(), "/graphql", query: @query, variables: @variables)
    assert %{
      "data" => %{
        "artists" => [%{"name" => "Slipknot"}]
      }
    } == json_response(response, 200)
  end

end
