defmodule YFFBackend.Program.Artist do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "artists" do
    field :name, :string
    field :summary, :string
    field :website, :string

    timestamps()
  end

  @doc false
  def changeset(artist, attrs) do
    artist
    |> cast(attrs, [:name, :summary, :website])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
