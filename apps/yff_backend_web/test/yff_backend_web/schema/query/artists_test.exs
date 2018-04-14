defmodule YFFBackendWeb.Schema.Query.ArtistsTest do
  use YFFBackendWeb.ConnCase, async: true

  setup do
    YFFBackend.DatabaseSeeder.insert_all!()
  end

  @query """
    {
      artists {
        name
      }
    }
  """
  test "artist field returns list of artists" do
    conn = build_conn()
    conn = post conn, "/graphql", query: @query

    assert %{
      "data" => %{
        "artists" => artist_response
      }
    } = json_response(conn, 200)

    assert Enum.take(artist_response, 3) == [
      %{"name" => "Alawishus Jones & the Outright Lies"},
      %{"name" => "Bohemian Nights"},
      %{"name" => "Bruce Watson"}
    ]
  end

  @query """
    query($filter: ArtistFilter!) {
      artists(filter: $filter) {
        name
      }
    }
  """
  @variables %{filter: %{matching: "Lady"}}
  test "artist filtered by matching name" do
    response = get(build_conn(), "/graphql", query: @query, variables: @variables)
    assert %{
      "data" => %{
        "artists" => artists_response
      }
    } = json_response(response, 200)

    assert artists_response == [
      %{"name" => "Lady Valiant"},
      %{"name" => "The Ladybirds" }
    ]
  end
end
