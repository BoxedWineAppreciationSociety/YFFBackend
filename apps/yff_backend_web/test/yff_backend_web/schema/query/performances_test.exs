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
        day
      }
    }
  """
  test "performances field returns performances" do
    conn = build_conn()
    response = post conn, "/graphql", query: @query

    assert %{
      "data" => %{
        "performances" => [ %{"time" => _, "day" => "FRIDAY"} | _ ]
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
        "performances" => perfomances_response
      }
    } = json_response(response, 200)

    assert [
        %{
          "id" => _,
          "artist" => %{
            "name" => "Rachel Clark"
          }
        },
        %{
          "id" => _,
          "artist" => %{
            "name" => "Guyy & the Fox"
          }
        },
        %{
          "id" => _,
          "artist" => %{
            "name" => "Lady Valiant"
          }
        }
        | _
    ] = perfomances_response
  end

  @query """
    query($day: Day!) {
      performances(day: $day) {
        id
        day
        artist {
          name
        }
      }
    }
  """
  @saturday "SATURDAY"
  @variables %{day: @saturday}
  test "filter performances by day" do
    response = get(build_conn(), "/graphql", query: @query, variables: @variables)

    assert %{
      "data" => %{
        "performances" => performances_response
      }
    } = json_response(response, 200)

    assert [
        %{
          "id" => _,
          "day" => @saturday,
          "artist" => %{
            "name" => "Yoga Loves Music"
          }
        },
        %{
          "id" => _,
          "day" => @saturday,
          "artist" => %{
            "name" => "The Ladybirds"
          }
        },
        %{
          "id" => _,
          "day" => @saturday,
          "artist" => %{
            "name" => "The Blue Yonder"
          }
        }
        | _
    ] = performances_response
  end
end
