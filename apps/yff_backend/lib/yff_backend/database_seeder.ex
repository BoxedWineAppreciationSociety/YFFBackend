defmodule YFFBackend.DatabaseSeeder do
  alias YFFBackend.{ Program.Artist, Program.Performance, Program }

  @artist_file Path.join(:code.priv_dir(:yff_backend), "repo/seeds/artists.json")
  @fri_perf_file Path.join(:code.priv_dir(:yff_backend), "repo/seeds/fri_performances.json")
  @sat_perf_file Path.join(:code.priv_dir(:yff_backend), "repo/seeds/sat_performances.json")
  @sun_perf_file Path.join(:code.priv_dir(:yff_backend), "repo/seeds/sun_performances.json")

  def insert_all!() do
    with [%Artist{} | _] = artist_list <- Enum.map(artists(), &insert_artist/1),
         [%Performance{} | _] = performance_list <- Enum.map(performances(), fn perf ->
          insert_performance(perf, artist_list)
         end)
    do
      :ok
    else
      [first | _] = error ->
        IO.inspect first
        raise "Something went wrong"
        :error
    end
  end

  def insert_artist(%{"name" => name} = artist_attrs) do
    case Program.get_artist_by_name(name) do
      nil ->
        {:ok, artist} = Program.create_artist(artist_attrs)
        artist
      %Artist{} = existing ->
        {:ok, artist} = Program.update_artist(existing, artist_attrs)
        artist
    end
  end

  def insert_performance(%{"time" => time_int, "artistId" => artist_id} = perf_attrs, _artists) do
    artists = artists()

    with %{"name" => name} = artist_json <- Enum.find(artists, &(Map.get(&1, "id") == artist_id)),
         %Artist{} = artist <- Program.get_artist_by_name(name),
        {:ok, %Performance{} = performance} <- create_performance(attrs_for_perf(perf_attrs, artist))
    do
      performance
    else
      {:error, changeset} -> IO.inspect changeset
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

  def performances() do
    Enum.reduce([@fri_perf_file, @sat_perf_file, @sun_perf_file], [], fn (file, list) ->
      with {:ok, body} <- File.read(file),
          {:ok, %{"performances" => performances }} <- Poison.decode(body)
      do
        list ++ performances
      else
        error -> raise error.inspect
      end
    end)
  end

  # TODO: Stage
  def attrs_for_perf(%{"time" => time_int} = attrs, artist) do
    time = Timex.from_unix(time_int)
    %{time: time, artist_id: artist.id}
  end

  def create_performance(attrs) do
    case YFFBackend.Repo.get_by(Performance, attrs) do
      nil -> Program.create_performance(attrs)
      %Performance{} = performance -> {:ok, performance}
    end
  end
end
