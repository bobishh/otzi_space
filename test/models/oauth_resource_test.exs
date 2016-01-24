defmodule OtziSpace.OauthResourceTest do
  use OtziSpace.ModelCase
  alias OtziSpace.OauthResource

  @valid_attrs %{access_token: "somecontent", name: "some content", uid: "some content", type: "some content", bio: "some content" }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = OauthResource.changeset(%OauthResource{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = OauthResource.changeset(%OauthResource{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "doesnt allow duplicated uid&type pairs" do
    changeset = OauthResource.changeset(%OauthResource{}, @valid_attrs)
    { :ok, _model } = Repo.insert(changeset)
    assert_raise( Ecto.ConstraintError,
                  ~r/constraint error when attempting to insert model/,
                  fn -> Repo.insert!(changeset) end)
  end
end
