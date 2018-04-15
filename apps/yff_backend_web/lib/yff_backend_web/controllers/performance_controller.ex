defmodule YFFBackendWeb.PerformanceController do
  use YFFBackendWeb, :controller

  alias YFFBackend.Program

  action_fallback YFFBackendWeb.FallbackController

  def index(conn, _params) do
    performances = Program.list_performances()
    render(conn, "index.json", performances: performances)
  end

  def show(conn, %{"id" => id}) do
    performance = Program.get_performance!(id)
    render(conn, "show.json", performance: performance)
  end
end
