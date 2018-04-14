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

  @query """
    {
      artists(order: DESC) {
        name
      }
    }
  """
  test "artists in descending order" do
    response = get(build_conn(), "/graphql", query: @query)
    assert %{
      "data" => %{
        "artists" => artists_response
      }
    } = json_response(response, 200)

    assert Enum.take(artists_response, 3) == [
      %{"name" => "Yoga Loves Music"},
      %{"name" => "Yackandandah Community Choir"},
      %{"name" => "William Alexander"}
    ]
  end

  @query """
    query($id: ID!) {
      artist(id: $id) {
        id
        name
        summary
      }
    }
  """
  test "get artist by ID" do
    artist_id = YFFBackend.Program.get_artist_by_name("The Coconut Kids").id
    variables = %{id: artist_id}
    response = get(build_conn(), "/graphql", query: @query, variables: variables)

    assert %{
      "data" => %{
        "artist" => artist_response
      }
    } = json_response(response, 200)

    assert %{
      "id" => ^artist_id,
      "name" => "The Coconut Kids",
      "summary" => "Infectiously fun" <> _
    } = artist_response
  end
end
