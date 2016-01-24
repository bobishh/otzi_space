defmodule OtziSpace.AuthControllerTest do
  use OtziSpace.ConnCase
  alias OtziSpace.Repo
  alias OtziSpace.User
  alias OtziSpace.Auth

  @email  "some@content.org"
  @password  "s3cR3tpa55"

  setup %{conn: conn} do
    changeset = User.changeset(%User{}, %{email: @email,
                                          name: "Some Content",
                                          password: @password,
                                          password_confirmation: @password,
                                          role_id: 1})
    { :ok, user } = Repo.insert(changeset)
    on_exit fn ->
      Repo.delete_all(User)
    end
    conn =
      conn
    |> bypass_through(OtziSpace.Router, :browser)
    |> get("/")
    {:ok, %{conn: conn, user: user}}
  end

  test "login", %{conn: conn} do
    login_conn =
      conn
    |> Auth.login(%User{id: 123})
    |> send_resp(:ok, "")
    next_conn = get(login_conn, "/")
    assert get_session(next_conn, :user_id) == 123
  end

  test "fails if no user present in db", %{conn: conn} do
    {result, code, _login_conn} = Auth.login_by_email_and_pw(conn, "ome@content.org", "s3cR3tpa55", [ repo: Repo ])
    assert code  == :not_found
    assert result == :error
  end

  test "sets user_id in session after login", %{conn: conn, user: user} do
    {:ok, login_conn} = Auth.login_by_email_and_pw(conn, @email, @password, [ repo: Repo ])
    logged_conn = send_resp(login_conn, :ok, "")
    next_conn = get(logged_conn, "/")
    assert next_conn.assigns.current_user != nil
    assert get_session(next_conn, :user_id) == user.id
  end

end
