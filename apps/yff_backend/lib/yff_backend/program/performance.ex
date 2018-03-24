defmodule YFFBackend.Program.Performance do
  use Ecto.Schema
  import Ecto.Changeset

  alias YFFBackend.Program.Artist


  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "performances" do
    field :time, :utc_datetime
    belongs_to :artist, Artist

    timestamps()
  end

  @doc false
  def changeset(performance, attrs) do
    performance
    |> cast(attrs, [:artist_id, :time])
    |> foreign_key_constraint(:artist)
    |> validate_required([:time, :artist_id])
  end
end
