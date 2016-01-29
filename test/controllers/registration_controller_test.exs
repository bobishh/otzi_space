defmodule OtziSpace.RegistrationControllerTest do
  use OtziSpace.ConnCase
  alias OtziSpace.Repo
  alias OtziSpace.User
  alias OtziSpace.Mailer
  import Mock

  @password "superpassword"
  @valid_params %{"user" => %{ "email" => Faker.Internet.email, "password" => @password, "password_confirmation" => @password }}
  @invalid_params %{"user" => %{ "email" => Faker.Internet.email, "password" => @password, "password_confirmation" => "bullshit"}}

  setup %{conn: conn} do
    on_exit fn ->
      Repo.delete_all User
    end
    { :ok, conn: conn }
  end

  test "creates user", %{conn: conn} do
    with_mock Mailer, [ send_welcome_html_email: fn(_user, _link) -> "sending an email" end] do
      conn
      |> post("/registrations", @valid_params)
      assert (Repo.one(User)).email == @valid_params["user"]["email"]
    end
  end

  test "yields errors if login failed", %{ conn: conn } do
    conn = conn
    |> post("/registrations", @invalid_params)
    assert get_flash(conn)["error"] == "Errors, check the form"
  end

  test "renders new user form", %{conn: conn} do
    resp_conn = conn
    |> get("/registrations/new", @valid_params)
    assert String.contains?(resp_conn.resp_body, "input")
  end

  test "mails confirmation email with correct token", %{conn: conn} do
    with_mock Mailer, [ send_welcome_html_email: fn(_user, _link) -> "sending an email" end ] do
      conn
      |> post("/registrations", @valid_params)
      user = Repo.get_by!(User, email: @valid_params["user"]["email"])
      confirmation_link =  OtziSpace.Endpoint.url <> confirmation_path(conn, :confirm, %{token: user.confirmation_token})
      assert called Mailer.send_welcome_html_email(:_, confirmation_link)
    end
  end

end
