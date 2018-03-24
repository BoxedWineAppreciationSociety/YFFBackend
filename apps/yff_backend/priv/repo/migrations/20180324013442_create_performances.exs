defmodule YFFBackend.Repo.Migrations.CreatePerformances do
  use Ecto.Migration

  def change do
    create table(:performances, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :artist_id, references(:artists, type: :binary_id), null: false
      add :time, :utc_datetime, null: false

      timestamps()
    end
  end
end
