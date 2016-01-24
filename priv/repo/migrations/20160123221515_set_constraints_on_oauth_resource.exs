defmodule OtziSpace.Repo.Migrations.SetConstraintsOnOauthResource do
  use Ecto.Migration

  def change do
    create unique_index(:oauth_resources, [:uid, :type])
  end
end
