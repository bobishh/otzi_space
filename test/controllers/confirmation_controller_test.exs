defmodule OtziSpace.ConfirmationControllerTest do
  use OtziSpace.ConnCase
  alias OtziSpace.TestHelpers
  alias OtziSpace.Repo
  alias OtziSpace.User

  setup %{conn: conn} do
    user = Repo.insert! TestHelpers.sample_user
    {:ok, conn: conn, user: user}
  end

  test "it updates unconfirmed user with correct token", %{conn: conn, user: user } do
    conn
    |> get("/registrations/confirm", %{ "token" => user.confirmation_token })
    user = Repo.get(User, user.id)
    assert user.confirmed == true
  end

  test "it sets flash", %{conn: conn, user: user} do
    resp = conn
    |> get("/registrations/confirm", %{ "token" => user.confirmation_token })
    assert get_flash(resp, :info) == "Account confirmed successfully."
  end
end
