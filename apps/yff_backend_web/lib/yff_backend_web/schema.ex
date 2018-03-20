defmodule YFFBackendWeb.Schema do
  use Absinthe.Schema

  query do
    field :artists, list_of(:artist) do
      resolve fn _, _ -> {:ok, YFFBackend.Program.list_artists} end
    end
  end

  object :artist do
    field :name, :string
    field :summary, :string
    field :website, :string
  end
end
