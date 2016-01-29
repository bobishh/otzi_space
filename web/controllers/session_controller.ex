defmodule OtziSpace.SessionController do
  use OtziSpace.Web, :controller
  import OtziSpace.Auth, only: [login_by_email_and_pw: 4, logout: 1]
  alias OtziSpace.Router.Helpers
  alias OtziSpace.Repo

  def create(conn, %{ "session" => %{ "email" => email, "password" => password }}) do
    case login_by_email_and_pw(conn, email, password, repo: Repo) do
      { :ok, conn } ->
        redirect(conn, to: Helpers.profile_path(conn, :index))
      { :error, reason, errors } ->
        render(conn, "new.html", %{ errors: errors })
    end
  end

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def delete(conn, params) do
    conn
    |> logout()
    |> redirect(to: Helpers.page_path(conn, :index))
  end

end
