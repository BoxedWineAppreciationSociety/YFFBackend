defmodule YFFBackendWeb.ArtistControllerTest do
  use YFFBackendWeb.ConnCase

  alias YFFBackend.Program

  @create_attrs %{name: "Slayer"}

  def fixture(:artist) do
    {:ok, artist} = Program.create_artist(@create_attrs)
    artist
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all artists", %{conn: conn} do
      conn = get conn, artist_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end
end
