defmodule YFFBackendWeb.Schema do
  use Absinthe.Schema

  alias YFFBackendWeb.Resolvers

  query do
    field :artists, list_of(:artist) do
      arg :filter, :artist_filter
      resolve &Resolvers.Program.artists/3
    end

    field :artist, :artist do
      arg :id, non_null(:id)
      resolve &Resolvers.Program.get_artist/3
    end

    field :performances, list_of(:performance) do
      resolve &Resolvers.Program.performances/3
    end
  end

  @desc "Artist or band that are performing at the festival"
  object :artist do
    field :id, :string
    field :name, :string
    field :summary, :string
    field :website, :string
 end

  input_object :artist_filter do
    field :matching, :string
  end

  @desc "Performance time of an artist performing at the festival"
  object :performance do
    field :id, :string
    field :time, :string
    field :day, :string

    field :artist, type: :artist do
      resolve &Resolvers.Program.artist_for_performance/3
    end
  end
end
