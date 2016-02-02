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

  def login_setup(conn) do
    user = TestHelpers.sample_user
    rsrc_changeset = Ecto.build_assoc(user, :oauth_resources, form_resource_attrs(@instagram_user))
    Repo.insert!(user)
    Repo.insert!(rsrc_changeset)
    { :ok, conn: conn, user: user }
  end

  def resource_taken_setup(conn) do
    user = TestHelpers.sample_user
    resource_owner = TestHelpers.sample_user
    resource_changeset = Ecto.build_assoc(resource_owner, :oauth_resources, form_resource_attrs(@instagram_user))
    conn = assign(conn, :current_user, user)
    Repo.insert!(user)
    Repo.insert!(resource_owner)
    Repo.insert!(resource_changeset)
    {:ok, conn: conn, user: user}
  end

  def create_resource_setup(conn) do
    user = TestHelpers.sample_user
    Repo.insert!(user)
    conn = conn
    |> assign(:current_user, user)
    {:ok, conn: conn, user: user}
  end

  def update_resource_setup(conn) do
    {:ok, conn: conn, user: user} = login_setup(conn)
    conn = conn
    |> assign(:current_user, user)
    {:ok, conn: conn, user: user}
  end

  setup %{conn: conn} = config do
    if config[:scenario] != nil do
      func_name = String.to_atom(Atom.to_string(config[:scenario]) <> "_setup")
      on_exit fn ->
        Repo.delete_all User
        Repo.delete_all OauthResource
      end
      apply __MODULE__, func_name, [conn]
    else
      {:ok, conn: conn}
    end
  end

  @tag scenario: :login
  test "calls elixtagram and logins user", %{conn: conn, user: user} do
    instagram_mocked fn ->
      logged_in_conn = conn
      |> get("/auth", @params)
      next_conn = get(logged_in_conn, "/", %{})
      assert next_conn.assigns.current_user.id == user.id
    end
  end

  @tag scenario: :create_resource
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

  test "does nothing and flashes error when no resource found", %{conn: conn} do
    instagram_mocked fn ->
      resp = conn
      |> get("/auth", @params)
      assert get_flash(resp, :error) == "User not found."
    end
  end

  @tag scenario: :resource_taken
  test "does nothing and flashes error if resource taken", %{ conn: conn, user: _user } do
    instagram_mocked fn ->
      resp = conn
      |> get("/auth", @params)
      assert resp.status == 302
      assert get_flash(resp, :error) == "Resource taken."
    end
  end

  @tag scenario: :update_resource
  test "update resource", %{conn: conn}  do
    instagram_mocked fn ->
      resp = conn
      |> get("/auth", @params)
      assert resp.status == 302
      assert get_flash(resp, :info) == "Resource updated successfully."
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
