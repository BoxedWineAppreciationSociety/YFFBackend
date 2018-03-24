defmodule YFFBackend.Repo.Migrations.CreatePerformances do
  use Ecto.Migration

  def up do
    DayEnum.create_type()
    create table(:performances, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :artist_id, references(:artists, type: :binary_id), null: false
      add :time, :utc_datetime, null: false
      add :day, :day

      timestamps()
    end
  end

  def down do
    drop table(:performances)
    DayEnum.drop_type()
  end
end
