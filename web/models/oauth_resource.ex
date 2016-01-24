defmodule OtziSpace.OauthResource do
  use OtziSpace.Web, :model

  schema "oauth_resources" do
    field :type, :string
    field :access_token, :string
    field :name, :string
    field :email, :string
    field :uid, :string
    field :username, :string
    belongs_to :user, OtziSpace.User

    timestamps
  end

  @required_fields ~w(type access_token name uid)
  @optional_fields ~w(name username email user_id)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
