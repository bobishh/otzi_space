defmodule OtziSpace.ArtistControllerTest do
  use OtziSpace.ConnCase
  alias OtziSpace.User
  alias OtziSpace.Repo

  setup do
    Repo.insert! %User{ name: "bob the artist", role_id: 1, email: "asdasdasd@test.test", password_hash: "ASd", confirmation_token: "TOKEN" }
    Repo.insert! %User{ name: "rob the artist", role_id: 1, email: "asd11adsad@test.test", password_hash: "asldkjalskdas", confirmation_token: "TOKEN" }
    on_exit fn() ->
      Repo.delete_all User
    end
    :ok
  end

  test "GET /artists", %{conn: conn} do
    conn = get conn, "/artists"
    assert html_response(conn, 200) =~ "bob the artist"
  end

  test "GET /artists/:id", %{conn: conn} do
    conn = get conn, "/artists/#{Repo.one(from u in User, limit: 1).id}"
    assert html_response(conn, 200) =~ "bob the artist"
  end

end
