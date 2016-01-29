defmodule OtziSpace.User do
  use OtziSpace.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :password_hash, :string
    field :bio, :binary
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :confirmation_token, :string, null: false
    field :confirmed, :boolean
    field :website, :string
    field :profile_picture, :string
    field :confirmation_sent, :boolean
    belongs_to :role, OtziSpace.Role
    has_many :oauth_resources,
             OtziSpace.OauthResource,
             on_delete: :delete_all

    timestamps
  end

  @required_fields ~w(email password password_confirmation)
  @admin_fields ~w(email password)
  @optional_fields ~w(name role_id bio profile_picture website)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """

# fuck this changeset
  def admin_changeset(model, params \\ :empty) do
    model
    |> cast(params, @admin_fields, @optional_fields)
    |> put_password_hash
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:name, min: 3, max: 20)
    |> validate_length(:password, min: 6, max: 100)
    |> unique_constraint(:email)
    |> validate_passwords()
    |> put_confirmation_token()
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

  defp put_confirmation_token(changeset) do
    case changeset do
      %Ecto.Changeset{ valid?: true, changes: %{ email: email }} ->
        token = Phoenix.Token.sign(OtziSpace.Endpoint, "user", email)
        put_change(changeset, :confirmation_token, token)
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
