defmodule OtziSpace.UserTest do
  use OtziSpace.ModelCase

  alias OtziSpace.Repo
  alias OtziSpace.User

  @valid_attrs %{email: "some content", name: "some content", password: "some content", password_confirmation: "some content", role_id: 1}
  @no_email %{name: "", password: "asdasda ", password_confirmation: "asdasda"}
  @different_passwords %{email: "some content", name: "some content", password: "somecontent", password_confirmation: "some content", role_id: 1}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset invalid when passwords don't match" do
    changeset = User.changeset(%User{}, @different_passwords)
    refute changeset.valid?
  end

  test "changeset invalid when no name email provided" do
    changeset = User.changeset(%User{}, @no_email)
    refute changeset.valid?
  end

  test "user unconfirmed after creation" do
    changeset = User.changeset(%User{}, @valid_attrs)
    {:ok, user} = Repo.insert changeset
    refute user.confirmed
  end

end
