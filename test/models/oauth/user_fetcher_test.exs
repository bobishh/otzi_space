defmodule OtziSpace.UserFetcherTest do
  use OtziSpace.ModelCase
  alias OtziSpace.Oauth
  alias OtziSpace.TestHelpers
  import Mock

  @params %{"code" => "superdupercode", "provider" => "instagram"}
  @instagram_user TestHelpers.instagram_user()

  test "calls elixtagram and returns oauth user" do
    with_mock Elixtagram, [ get_token!: fn (code: _code) -> %{access_token: "X_TOKEN_X"} end,
                            user: fn (_id, _token) -> @instagram_user end,
                            configure: fn (:global, _token) -> {:ok, []} end ] do
      { :ok, user } = Oauth.UserFetcher.fetch_oauth_user(@params)
      assert user.name == @instagram_user.full_name
    end
  end

end
