defmodule OtziSpace.AuthTest do
  use OtziSpace.ConnCase
  alias OtziSpace.Auth
  alias OtziSpace.User

  setup %{conn: conn} do
    conn =
      conn
        |> bypass_through(OtziSpace.Router, :browser)
        |> get("/")
    {:ok, %{conn: conn}}
  end

  test "authenticate_users halts when no current_user present on conn", %{conn: conn} do
    conn = Auth.authenticate_user(conn, [])
    assert conn.halted
  end

  test "authenticate_user won't halt if current_user present on conn", %{conn: conn} do
    conn = assign(conn, :current_user, %User{name: "NAME"})
    conn = Auth.authenticate_user(conn, [])
    refute conn.halted
  end



end
