defmodule OtziSpace.Repo.Migrations.ChangeUserModel do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :profile_picture, :string
      add :bio, :text
      add :website, :string
    end
  end
end
