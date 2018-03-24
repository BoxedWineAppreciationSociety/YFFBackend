defmodule YFFBackend.Program do
  @moduledoc """
  The Program context.
  """

  import Ecto.Query, warn: false
  alias YFFBackend.Repo

  alias YFFBackend.Program.Artist

  @doc """
  Returns the list of artists, with requested filters

  ## Examples

      iex> list_artists()
      [%Artist{}, ...]

      iex> list_artists(%{filter: %{matching: "Foo"}})
      [%Artist{}, ...]

  """
  def list_artists(args \\ %{})
  def list_artists(args) do
    args
    |> Enum.reduce(Artist, fn
      {:filter, filter}, query ->
        query |> filter_with(filter)
    end)
    |> order_by(:name)
    |> Repo.all
  end

  defp filter_with(query, filter) do
    Enum.reduce(filter, query, fn
      {:matching, match}, query ->
        from q in query, where: ilike(q.name, ^"%#{match}%")
    end)
  end

  @doc """
  Gets a single artist.

  Raises `Ecto.NoResultsError` if the Artist does not exist.

  ## Examples

      iex> get_artist!(123)
      %Artist{}

      iex> get_artist!(456)
      ** (Ecto.NoResultsError)

  """
  def get_artist!(id), do: Repo.get!(Artist, id)

  @doc """
  Gets a single artist by name.

  Raises `Ecto.NoResultsError` if the Artist does not exist.

  ## Examples

      iex> get_artist_by_name!("Slipknot")
      %Artist{}

      iex> get_artist!("Taylor Swift")
      ** (Ecto.NoResultsError)

  """
  def get_artist_by_name!(name) do
    query = from a in Artist, where: a.name == ^name

    Repo.one!(query)
  end

  @doc """
  Gets a single artist by name.

  Raises `Ecto.NoResultsError` if the Artist does not exist.

  ## Examples

      iex> get_artist_by_name!("Slipknot")
      %Artist{}

      iex> get_artist!("Taylor Swift")
      ** (Ecto.NoResultsError)

  """
  def get_artist_by_name(name) do
    query = from a in Artist, where: a.name == ^name

    Repo.one(query)
  end

  @doc """
  Creates a artist.

  ## Examples

      iex> create_artist(%{field: value})
      {:ok, %Artist{}}

      iex> create_artist(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_artist(attrs \\ %{}) do
    %Artist{}
    |> Artist.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a artist.

  ## Examples

      iex> update_artist(artist, %{field: new_value})
      {:ok, %Artist{}}

      iex> update_artist(artist, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_artist(%Artist{} = artist, attrs) do
    artist
    |> Artist.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Artist.

  ## Examples

      iex> delete_artist(artist)
      {:ok, %Artist{}}

      iex> delete_artist(artist)
      {:error, %Ecto.Changeset{}}

  """
  def delete_artist(%Artist{} = artist) do
    Repo.delete(artist)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking artist changes.

  ## Examples

      iex> change_artist(artist)
      %Ecto.Changeset{source: %Artist{}}

  """
  def change_artist(%Artist{} = artist) do
    Artist.changeset(artist, %{})
  end

  alias YFFBackend.Program.Performance

  @doc """
  Returns the list of performances.

  ## Examples

      iex> list_performances()
      [%Performance{}, ...]

  """
  def list_performances do
    Performance
    |> preload(:artist)
    |> Repo.all
  end

  @doc """
  Gets a single performance.

  Raises `Ecto.NoResultsError` if the Performance does not exist.

  ## Examples

      iex> get_performance!(123)
      %Performance{}

      iex> get_performance!(456)
      ** (Ecto.NoResultsError)

  """
  def get_performance!(id) do
    Performance
    |> preload(:artist)
    |> Repo.get!(id)
  end

  @doc """
  Creates a performance.

  ## Examples

      iex> create_performance(%{field: value})
      {:ok, %Performance{}}

      iex> create_performance(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_performance(attrs \\ %{}) do
    %Performance{}
    |> Performance.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a performance.

  ## Examples

      iex> update_performance(performance, %{field: new_value})
      {:ok, %Performance{}}

      iex> update_performance(performance, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_performance(%Performance{} = performance, attrs) do
    performance
    |> Performance.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Performance.

  ## Examples

      iex> delete_performance(performance)
      {:ok, %Performance{}}

      iex> delete_performance(performance)
      {:error, %Ecto.Changeset{}}

  """
  def delete_performance(%Performance{} = performance) do
    Repo.delete(performance)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking performance changes.

  ## Examples

      iex> change_performance(performance)
      %Ecto.Changeset{source: %Performance{}}

  """
  def change_performance(%Performance{} = performance) do
    Performance.changeset(performance, %{})
  end
end
