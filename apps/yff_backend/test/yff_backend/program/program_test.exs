defmodule YFFBackend.ProgramTest do
  require IEx

  use YFFBackend.DataCase

  alias YFFBackend.Program

  describe "artists" do
    alias YFFBackend.Program.Artist

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def artist_fixture(attrs \\ %{}) do
      {:ok, artist} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Program.create_artist()

      artist
    end

    test "list_artists/0 returns all artists" do
      artist = artist_fixture()
      assert Program.list_artists() == [artist]
    end

    test "get_artist!/1 returns the artist with given id" do
      artist = artist_fixture()
      assert Program.get_artist!(artist.id) == artist
    end

    test "get_artist_by_name!/1 returns the artist with given name" do
      artist = artist_fixture()
      assert Program.get_artist_by_name!(artist.name) == artist
    end

    test "get_artist_by_name!/1 raises Ecto.NoResultsError if artist does not exist" do
      assert_raise Ecto.NoResultsError, fn ->
        Program.get_artist_by_name!("Jimi Hendrix") == "Not true"
      end
    end

    test "get_artist_by_name/1 returns the artist with given name" do
      artist = artist_fixture()
      assert Program.get_artist_by_name(artist.name) == artist
    end

    test "get_artist_by_name/1 returns nil if the artist does not exist" do
      assert Program.get_artist_by_name("Jimi Hendrix") == nil
    end

    test "create_artist/1 with valid data creates a artist" do
      assert {:ok, %Artist{} = artist} = Program.create_artist(@valid_attrs)
      assert artist.name == "some name"
    end

    test "create_artist/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Program.create_artist(@invalid_attrs)
    end

    test "update_artist/2 with valid data updates the artist" do
      artist = artist_fixture()
      assert {:ok, artist} = Program.update_artist(artist, @update_attrs)
      assert %Artist{} = artist
      assert artist.name == "some updated name"
    end

    test "update_artist/2 with invalid data returns error changeset" do
      artist = artist_fixture()
      assert {:error, %Ecto.Changeset{}} = Program.update_artist(artist, @invalid_attrs)
      assert artist == Program.get_artist!(artist.id)
    end

    test "delete_artist/1 deletes the artist" do
      artist = artist_fixture()
      assert {:ok, %Artist{}} = Program.delete_artist(artist)
      assert_raise Ecto.NoResultsError, fn -> Program.get_artist!(artist.id) end
    end

    test "change_artist/1 returns a artist changeset" do
      artist = artist_fixture()
      assert %Ecto.Changeset{} = Program.change_artist(artist)
    end
  end

  describe "performances" do
    alias YFFBackend.Program.Artist
    alias YFFBackend.Program.Performance

    @artist_attrs %{name: "Slayer"}

    def attrs_for_performance(%Artist{} = artist, attrs \\ %{}) do
      {:ok, time, 0} = DateTime.from_iso8601("2018-03-24T14:30:00.000Z")

      attrs
      |> Enum.into(%{day: :saturday, time: time, artist_id: artist.id})
    end

    setup do
      {:ok, artist} = Program.create_artist(@artist_attrs)
      {:ok, performance} = Program.create_performance(attrs_for_performance(artist))
      performance_with_artist = Performance
        |> preload(:artist)
        |> where(id: ^performance.id)
        |> Repo.one!

      %{artist: artist, performance: performance_with_artist}
    end

    test "create_performance/1 with valid data creates a performance", %{artist: artist} do
      assert {:ok, %Performance{}} = Program.create_performance(attrs_for_performance(artist))
    end

    test "list_performances/0 returns all performances", %{performance: performance} do
      assert Program.list_performances() == [performance]
    end

    test "get_performance!/1 returns the performance with given id", %{performance: performance} do
      assert Program.get_performance!(performance.id) == performance
    end

    @invalid_attrs %{artist_id: nil}

    test "create_performance/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Program.create_performance(@invalid_attrs)
    end

    test "update_performance/2 with valid data updates the performance", %{performance: performance} do
      {:ok, time, 0} = DateTime.from_iso8601("2018-03-25T14:30:00.000Z")
      update_attrs = %{time: time, day: :sunday}
      assert {:ok, performance} = Program.update_performance(performance, update_attrs)
      assert %Performance{} = performance
    end

    test "update_performance/2 with invalid data returns error changeset", %{performance: performance} do
      assert {:error, %Ecto.Changeset{}} = Program.update_performance(performance, @invalid_attrs)
      assert performance == Program.get_performance!(performance.id)
    end

    test "delete_performance/1 deletes the performance", %{performance: performance} do
      assert {:ok, %Performance{}} = Program.delete_performance(performance)
      assert_raise Ecto.NoResultsError, fn -> Program.get_performance!(performance.id) end
    end

    test "change_performance/1 returns a performance changeset", %{performance: performance} do
      assert %Ecto.Changeset{} = Program.change_performance(performance)
    end
  end
end
