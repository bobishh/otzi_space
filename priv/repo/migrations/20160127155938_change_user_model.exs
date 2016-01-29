defmodule OtziSpace.Repo.Migrations.ChangeUserModel do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :username
      add :confirmation_token, :string, null: false
    end
  end
end
