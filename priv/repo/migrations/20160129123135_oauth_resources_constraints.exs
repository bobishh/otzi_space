defmodule OtziSpace.Repo.Migrations.OauthResourcesConstraints do
  use Ecto.Migration

  def change do
    drop_if_exists index(:oauth_resources, [:user_id, :type])
    alter table(:oauth_resources) do
      modify :user_id, references(:users, on_delete: :delete_all)
    end
    create unique_index(:oauth_resources, [:user_id, :type])
  end
end
