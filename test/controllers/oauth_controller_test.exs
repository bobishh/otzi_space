defmodule OtziSpace.OauthControllerTest do
  use OtziSpace.ConnCase
  alias OtziSpace.TestHelpers
  alias OtziSpace.Repo
  alias OtziSpace.OauthResource
  alias OtziSpace.User
  import Mock
  @params %{"code" => "superdupercode", "provider" => "instagram"}
  @instagram_user TestHelpers.instagram_user()
  @another_instagram TestHelpers.instagram_user()
  @access_token "X_TOKEN_X"

  setup %{conn: conn} = config do
    if config[:existant_user] do
      user1 = TestHelpers.sample_user()
      user2 = TestHelpers.sample_user()
      resource_chset = Ecto.build_assoc(user1,
                                        :oauth_resources,
                                        form_resource_attrs(@instagram_user))
      {:ok, user1 } = Repo.insert(user1)
      {:ok, user2 } = Repo.insert(user2)
      if config[:logged_in] do
        conn = assign(conn, :current_user, user1)
        if config[:resource_taken] do
          Repo.insert(Ecto.build_assoc(user2,
                                       :oauth_resources,
                                       form_resource_attrs(@instagram_user)))

        end
      else
        Repo.insert resource_chset
      end
    end
    on_exit fn ->
      Repo.delete_all User
      Repo.delete_all OauthResource
    end
    { :ok, conn: conn }
  end

  # TODO:
  # test "mails new password to a user"
  # test "flashes a message when resource taken"

  @tag existant_user: true
  test "calls elixtagram and logins user", %{conn: conn} do
    instagram_mocked fn ->
      logged_in_conn = conn
      |> get("/auth", @params)
      next_conn = get(logged_in_conn, "/", %{})
      assert next_conn.assigns.current_user != nil
    end
  end

  @tag existant_user: true, logged_in: true
  test "ties resource when user present", %{conn: conn} do
    instagram_mocked fn ->
      res = Repo.one(OauthResource)
      # no resource before oauth call
      assert res == nil
      conn
      |> get("/auth", @params)
      res = Repo.one(OauthResource)
      assert res.access_token == @access_token
    end
  end

  test "does nothing and flashes error when no resource found" do
    instagram_mocked fn ->
      resp = conn
      |> get("/auth", @params)
      assert get_flash(resp, :error) == "User not found."
    end
  end

  @tag logged_in: true, existant_user: true, resource_taken: true
  test "does nothing and flashes error if resource taken", %{ conn: conn } do
    instagram_mocked fn ->
      resp = conn
      |> get("/auth", @params)
      assert get_flash(resp, :error) == "Resource taken."
    end
  end

  defp instagram_mocked(function) do
    with_mock Elixtagram, [ get_token!: fn (code: _code) -> %{ access_token: @access_token } end,
                          user: fn (_id, _token) -> @instagram_user end,
                          authorize_url!: fn () -> "authorized_url" end,
                          configure: fn () -> {:ok, []} end,
                          configure: fn (:global, _token) -> {:ok, []} end ] do
      function.()
    end
  end

  defp form_resource_attrs(oauth_user) do
    %{ name: oauth_user.full_name,
       type: "instagram",
       username: oauth_user.username,
       uid: oauth_user.id,
       access_token: @access_token }
  end
end
