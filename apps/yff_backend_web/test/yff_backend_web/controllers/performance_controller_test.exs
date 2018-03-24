defmodule YFFBackendWeb.PerformanceControllerTest do
  use YFFBackendWeb.ConnCase

  alias YFFBackend.Program

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all performances", %{conn: conn} do
      conn = get conn, performance_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end
end
