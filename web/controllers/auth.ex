defmodule OtziSpace.Auth do
  import Phoenix.Controller
  import Comeonin.Bcrypt, only: [checkpw: 2]
  import Plug.Conn
  alias OtziSpace.User
  alias OtziSpace.Router.Helpers

  def init(opts) do
    Keyword.fetch(opts, :repo)
  end

  def login(conn, user) do
    conn
    |> put_session(:user_id, user.id)
  end

  def login_by_email_and_pw(conn, email, pw, opts) do
    {:ok, repo} = Keyword.fetch(opts, :repo)
    user = repo.get_by(User, email: email)
    cond do
      user && checkpw(pw, user.password_hash) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        {:error, :not_found, conn}
    end
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)
    cond do
      user = conn.assigns[:current_user] ->
        put_current_user(conn, user)
      user = user_id && repo.get(OtziSpace.User, user_id) ->
        put_current_user(conn, user)
      true ->
        assign(conn, :current_user, nil)
    end
  end

  def put_current_user(conn, user) do
    assign(conn, :current_user, user)
  end

  def authenticate_user(conn, _params) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access this page")
      |> redirect(to: Helpers.page_path(conn, :index))
      |> halt()
    end
  end
end
