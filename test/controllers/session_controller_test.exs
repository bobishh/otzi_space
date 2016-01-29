defmodule OtziSpace.SessionControllerTest do
  use OtziSpace.ConnCase
  alias OtziSpace.User

  @user_changeset User.changeset(%User{}, %{ name: "some content",
                                             email: "some content",
                                             password: "some content",
                                             password_confirmation: "some content" })
  setup %{conn: conn} do
    { :ok, user } = Repo.insert(@user_changeset)
    on_exit fn ->
      Repo.delete_all User
    end
    { :ok, conn: conn, user: user }
  end

  test "puts user_id in session for user logged in with valid credentials", %{ conn: conn, user: user } do
    logged_conn = conn
    |> post("/sessions", form_credentials(user))
    assert logged_conn.status == 302
    assert get_session(logged_conn, :user_id) == user.id
  end

  test "puts user_id in session for user logged in with invalid credentials", %{ conn: conn, user: _user } do
    logged_conn = conn
    |> post("/sessions", %{"session" => %{ "email" => "bullshit", "password" => "bullshit"}})
    assert get_session(logged_conn, :user_id) == nil
  end

  defp form_credentials(user) do
    %{"session" => %{ "email" =>  user.email, "password" => user.password }}
  end
end
