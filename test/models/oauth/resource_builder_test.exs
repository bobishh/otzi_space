defmodule OtziSpace.OauthResourceBuilderTest do
  alias OtziSpace.OauthResource
  use OtziSpace.ModelCase
  alias OtziSpace.TestHelpers
  alias OtziSpace.Oauth
  alias OtziSpace.Repo
  alias OtziSpace.User

  @oauth_user TestHelpers.form_oauth_user()

  setup do
    { :ok, user } = TestHelpers.create_user(@oauth_user)
    on_exit fn ->
      Repo.delete_all(OauthResource)
      Repo.delete_all(User)
    end
    { :ok, user: user }
  end

  test "it creates resource", %{ user: user } do
    { res, _resource } = Oauth.ResourceBuilder.create_resource(user, @oauth_user)
    assert res == :ok
  end

end
