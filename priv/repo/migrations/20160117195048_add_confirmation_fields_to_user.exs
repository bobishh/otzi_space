defmodule OtziSpace.Repo.Migrations.AddConfirmationFieldsToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :confirmed, :boolean
      add :confirmation_sent, :boolean
    end
  end

end
