defmodule OtziSpace.Repo.Migrations.AddProfilePictureToOauthResources do
  use Ecto.Migration

  def change do
    alter table(:oauth_resources) do
      add :profile_picture, :string
    end
  end
end
