defmodule OtziSpace.ProfileControllerTest do
  use OtziSpace.ConnCase
  alias OtziSpace.TestHelpers

  @user TestHelpers.sample_user

  test "redirects to root when unauthenticated", %{conn: conn} do
    conn = conn
    |> get("/profile", %{})
    assert conn.status == 302
  end

  test "200 when authenticated", %{conn: conn} do
    conn = conn
    |> assign(:current_user, @user)
    |> get("/profile", %{})
    assert conn.status == 200
  end
end
