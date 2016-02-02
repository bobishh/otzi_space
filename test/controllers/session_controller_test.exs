defmodule OtziSpace.SessionControllerTest do
  use OtziSpace.ConnCase
  alias OtziSpace.User

  @user_changeset User.changeset(%User{}, %{ name: "some content",
                                             email: "some content",
                                             password: "some content",
                                             password_confirmation: "some content" })
  setup %{conn: conn} = config do
    user = Repo.insert!(@user_changeset)
    on_exit fn ->
      Repo.delete_all User
    end
    if config[:logged_in] do
      # if logged in, pass conn with user assigned
      conn = conn
      |> bypass_through(OtziSpace.Router, :browser)
      |> get("/")
      |> assign(:current_user, user)
      |> put_session(:user_id, user.id)
    end
    { :ok, conn: conn, user: user }
  end

  test "puts user_id in session for user logged in with valid credentials", %{ conn: conn, user: user } do
    logged_conn = conn
    |> post("/sessions", form_credentials(user))
    assert logged_conn.status == 302
    assert get_session(logged_conn, :user_id) == user.id
  end

  @tag logged_in: true
  test "#logout logs out user", %{conn: conn, user: user} do
    # initially user present on conn
    assert conn.assigns.current_user == user
    resp = conn
    |> delete("/sessions/#{user.id}")
    assert resp.status == 302
    assert resp.assigns.current_user == nil
    assert get_flash(resp, :info) == "Goodbye!"
  end

  test "sets flash in error case", %{conn: conn} do
    resp = conn
    |> post("/sessions", invalid_credentials())
    assert get_flash(resp, :error) == "Invalid credentials."
  end

  test "does not login with wrong credentials", %{ conn: conn, user: _user } do
    logged_conn = conn
    |> post("/sessions", %{"session" => %{ "email" => "bullshit", "password" => "bullshit"}})
    assert get_session(logged_conn, :user_id) == nil
  end

  defp form_credentials(user) do
    %{"session" => %{ "email" =>  user.email, "password" => user.password }}
  end

  defp invalid_credentials do
    %{"session" => %{ "email" =>  "WRONG@EMAIL.WTF", "password" => "GIBBERISH" }}
  end
end
