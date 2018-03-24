defmodule YFFBackendWeb.Schema do
  use Absinthe.Schema

  alias YFFBackendWeb.Resolvers

  query do
    field :artists, list_of(:artist) do
      arg :filter, :artist_filter
      resolve &Resolvers.Program.artists/3
    end
  end

  @desc "Artist or band that are performing at the festival"
  object :artist do
    field :name, :string
    field :summary, :string
    field :website, :string
  end

  input_object :artist_filter do
    field :matching, :string
  end
end
