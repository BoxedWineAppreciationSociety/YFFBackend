defmodule YFFBackend.DatabaseSeeder do
  alias YFFBackend.{ Program.Artist, Program }

  @artist_file Path.join(:code.priv_dir(:yff_backend), "repo/seeds/artists.json")

  def insert_all!() do
    artists() |> Enum.each(&insert_artist/1)
  end

  def insert_artist(%{"name" => name} = artist_attrs) do
    case Program.get_artist_by_name(name) do
      nil ->  Program.create_artist(artist_attrs)
      %Artist{} = existing -> Program.update_artist(existing, artist_attrs)
    end
  end

  def artists() do
    with {:ok, body} <- File.read(@artist_file),
         {:ok, %{"artists" => artists}} <- Poison.decode(body)
    do
      artists
    else
      error -> error
    end
  end
end
