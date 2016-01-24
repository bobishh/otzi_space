defmodule OtziSpace.OauthControllerTest do
  use OtziSpace.ConnCase
  alias OtziSpace.TestHelpers
  import Mock

  @params %{"code" => "superdupercode", "provider" => "instagram"}
  @instagram_user TestHelpers.instagram_user()

  test "calls elixtagram and logins user", %{conn: conn} do
    instagram_mocked fn ->
      logged_in_conn = conn
      |> get("/auth", @params)
      next_conn = get(logged_in_conn, "/", %{})
      assert next_conn.assigns.current_user != nil
    end
  end

  # test "mails new password to a user"
  # test "creates user if not existed"
  # test "logins user if exist"

  def instagram_mocked(function) do
    with_mock Elixtagram, [ get_token!: fn (code: _code) -> %{access_token: "X_TOKEN_X"} end,
                          user: fn (_id, _token) -> @instagram_user end,
                          authorize_url!: fn () -> "authorized_url" end,
                          configure: fn () -> {:ok, []} end,
                          configure: fn (:global, _token) -> {:ok, []} end ] do
      function.()
    end
  end

end
