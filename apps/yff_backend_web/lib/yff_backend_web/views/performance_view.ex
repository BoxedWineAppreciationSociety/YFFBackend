defmodule YFFBackendWeb.PerformanceView do
  use YFFBackendWeb, :view
  alias YFFBackendWeb.PerformanceView

  def render("index.json", %{performances: performances}) do
    %{data: render_many(performances, PerformanceView, "performance.json")}
  end

  def render("show.json", %{performance: performance}) do
    %{data: render_one(performance, PerformanceView, "performance.json")}
  end

  def render("performance.json", %{performance: performance}) do
    %{id: performance.id,
      time: DateTime.to_string(performance.time),
      day: performance.day,
      artist_id: performance.artist_id}
  end
end
