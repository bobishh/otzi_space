defmodule OtziSpace.PageControllerTest do
  use OtziSpace.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "otzi.space"
    assert html_response(conn, 200) =~ "marketplace for tattoo artists"
  end
end
