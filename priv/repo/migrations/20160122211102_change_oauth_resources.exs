defmodule OtziSpace.Repo.Migrations.ChangeOauthResources do
  use Ecto.Migration

  def change do
    alter table(:oauth_resources) do
      add :uid, :string
      add :username, :string
    end
  end
end
