# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     YFFBackend.Repo.insert!(%YFFBackend.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.show

defmodule YFFBackend.DatabaseSeeder do
  alias YFFBackend.{ Program.Artist, Program }

  @artist_file Path.join(:code.priv_dir(:yff_backend), "repo/seeds/artists.json")

  def insert_all!() do
    artists() |> Enum.each(&insert_artist/1)
  end

  def insert_artist(%{"name" => name} = artist) do
    case Program.get_artist_by_name(name) do
      nil ->  Program.create_artist(artist)
      %Artist{} = artist -> {:ok, artist}
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

YFFBackend.DatabaseSeeder.insert_all!()
