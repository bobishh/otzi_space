defmodule OtziSpace.RegistrationController do
  use OtziSpace.Web, :controller
  alias OtziSpace.Repo
  alias OtziSpace.User
  alias OtziSpace.Mailer
  alias OtziSpace.Router.Helpers
  import OtziSpace.Auth, only: [authenticate_user: 2, login: 2]
  plug :authenticate_user when action in [:delete]

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      { :ok, user } ->
        successful_callback(conn, user)
      { :error, changeset } ->
        failure_callback(conn, changeset)
    end
  end

  def new(conn, params) do
    user_params = params["user"] || %{}
    changeset = User.changeset(%User{}, user_params)
    render(conn, "new.html", %{changeset: changeset})
  end

  def delete(conn, _params) do
    current_user = conn.assigns["current_user"]
    case Repo.delete(current_user) do
      { :ok, _ } ->
        redirect(conn, to: Helpers.page_path(conn, :index))
      _ ->
        redirect(conn, to: Helpers.profile_path(conn, :index))
    end
  end

  defp successful_callback(conn, user) do
    IO.puts inspect(user)
    IO.puts inspect(confirmation_link(conn, user))
    Mailer.send_welcome_html_email(user, confirmation_link(conn, user))
    conn
    |> login(user)
    |> put_flash(:info, gettext("Check your mail, bro"))
    |> redirect(to: Helpers.page_path(conn, :index))
  end

  defp failure_callback(conn, changeset) do
    conn
    |> put_flash(:error, "Errors, check the form")
    |> render("new.html", changeset: changeset)
  end

  defp confirmation_link(conn, user) do
    OtziSpace.Endpoint.url <> Helpers.confirmation_path(conn,
                                                        :confirm,
                                                        %{ token: user.confirmation_token })
  end
end
