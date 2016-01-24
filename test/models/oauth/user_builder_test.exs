defmodule OtziSpace.OauthUserBuilderTest do
  use OtziSpace.ModelCase
  alias OtziSpace.Oauth
  alias OtziSpace.TestHelpers

  @oauth_user TestHelpers.form_oauth_user

  setup do
    { result, user } = Oauth.UserBuilder.create_user(@oauth_user)
    {:ok, result: result, user: user}
  end

  test "it creates user", %{result: result, user: _user} do
    assert result == :ok
  end

  test "with password", %{result: _result, user: user} do
    assert user.password != nil
  end

end
