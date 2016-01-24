defmodule OtziSpace.Repo.Migrations.CreateOauthResource do
  use Ecto.Migration

  def change do
    create table(:oauth_resources) do
      add :type, :string
      add :access_token, :string
      add :name, :string
      add :email, :string
      add :user_id, :integer, references: :user

      timestamps
    end

  end
end
