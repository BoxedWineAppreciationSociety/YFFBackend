defmodule YFFBackendWeb.Schema.Query.PerformancesTest do
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

    @artists
    |> Enum.map(fn artist ->
      {:ok, performance} = Program.create_performance(%{
        time: DateTime.utc_now,
        artist_id: Program.get_artist_by_name!(artist.name).id
      })
      performance
    end)

    :ok
  end

  # TODO Make custom scalar type for date format
  @query """
    {
      performances {
        time
      }
    }
  """
  test "performances field returns performances" do
    conn = build_conn()
    response = post conn, "/graphql", query: @query

    assert %{
      "data" => %{
        "performances" => [
          %{"time" => _},
          %{"time" => _},
          %{"time" => _},
        ]
      }
    } = json_response(response, 200)
  end

  @query """
    {
      performances {
        id
        artist {
          name
        }
      }
    }
  """
  test "can list related artist name" do
    conn = build_conn()
    response = post conn, "/graphql", query: @query

    assert %{
      "data" => %{
        "performances" => [
          %{
            "id" => _,
            "artist" => %{
              "name" => "U2"
            }
          },
          %{
            "id" => _,
            "artist" => %{
              "name" => "Slipknot"
            }
          },
          %{
            "id" => _,
            "artist" => %{
              "name" => "Taylor Swift"
            }
          }
        ]
      }
    } = json_response(response, 200)
  end
end
