defmodule YFFBackend.Repo.Migrations.AddAboutFieldsToArtists do
  use Ecto.Migration

  def change do
    alter table("artists") do
      add :summary, :text
      add :website, :text
    end
  end
end
