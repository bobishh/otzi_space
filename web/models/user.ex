defmodule OtziSpace.User do
  use OtziSpace.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :confirmed, :boolean
    field :confirmation_sent, :boolean
    belongs_to :role, OtziSpace.Role

    timestamps
  end

  @required_fields ~w(name email password password_confirmation role_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """

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
