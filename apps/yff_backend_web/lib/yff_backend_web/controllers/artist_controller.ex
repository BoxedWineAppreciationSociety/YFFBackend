defmodule YFFBackendWeb.ArtistController do
  use YFFBackendWeb, :controller

  alias YFFBackend.Program
  alias YFFBackend.Program.Artist

  action_fallback YFFBackendWeb.FallbackController

  def index(conn, _params) do
    artists = Program.list_artists()
    render(conn, "index.json", artists: artists)
  end

  def create(conn, %{"artist" => artist_params}) do
    with {:ok, %Artist{} = artist} <- Program.create_artist(artist_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", artist_path(conn, :show, artist))
      |> render("show.json", artist: artist)
    end
  end

  def show(conn, %{"id" => id}) do
    artist = Program.get_artist!(id)
    render(conn, "show.json", artist: artist)
  end

  def update(conn, %{"id" => id, "artist" => artist_params}) do
    artist = Program.get_artist!(id)

    with {:ok, %Artist{} = artist} <- Program.update_artist(artist, artist_params) do
      render(conn, "show.json", artist: artist)
    end
  end

  def delete(conn, %{"id" => id}) do
    artist = Program.get_artist!(id)
    with {:ok, %Artist{}} <- Program.delete_artist(artist) do
      send_resp(conn, :no_content, "")
    end
  end
end
