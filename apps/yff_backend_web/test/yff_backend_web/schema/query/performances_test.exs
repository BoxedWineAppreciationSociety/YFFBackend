defmodule YFFBackendWeb.Schema.Query.PerformancesTest do
  use YFFBackendWeb.ConnCase, async: true

  alias YFFBackend.Program

  setup do
    YFFBackend.DatabaseSeeder.insert_all!()
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
