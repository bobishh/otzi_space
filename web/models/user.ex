defmodule OtziSpace.User do
  use OtziSpace.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :password_hash, :string
    field :bio, :binary
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :confirmed, :boolean
    field :username, :string
    field :website, :string
    field :profile_picture, :string
    field :confirmation_sent, :boolean
    belongs_to :role, OtziSpace.Role
    has_many :oauth_resources, OtziSpace.OauthResource

    timestamps
  end

  @oauth_fields ~w(name password bio username website profile_picture)
  @required_fields ~w(name password password_confirmation)
  @optional_fields ~w(email role_id bio profile_picture)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """


  def oauth_changeset(model, params \\ :empty) do
    model
    |> cast(params, @oauth_fields, @optional_fields)
    |> put_password_hash
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:name, min: 3, max: 20)
    |> validate_length(:password, min: 6, max: 100)
    |> validate_passwords()
    |> put_password_hash()
  end

  defp validate_passwords(changeset) do
    case changeset do
        %Ecto.Changeset{ valid?: true,
                         changes: %{ password: pass,
                                     password_confirmation: pass } } ->
          changeset
        %Ecto.Changeset{ valid?: true,
                         changes: %{ password: pass,
                                     password_confirmation: pass_conf } } ->
          add_error(changeset, :password, "passwords don't match")
        _ -> changeset
    end
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{ valid?: true,
                       changes: %{ password: pass } } ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ -> changeset
    end
  end
end
