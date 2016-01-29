defmodule OtziSpace.ConfirmationController do
  use OtziSpace.Web, :controller
  alias OtziSpace.Repo
  alias OtziSpace.User
  alias OtziSpace.Router.Helpers

  use OtziSpace.Web, :controller
  # registration confirmation callback here
  def confirm(conn, %{"token" => token}) do
    cond do
      user = Repo.get_by(User, confirmation_token: token) ->
        Repo.update!(Ecto.Changeset.change(user, %{confirmed: true}))
        conn
        |> put_flash(:info, "Account confirmed successfully.")
        |> redirect(to: Helpers.profile_path(conn, :index))
      true ->
        conn
        |> put_flash(:error, "Wrong token.")
        |> redirect(to: Helpers.page_path(conn, :index))
    end
  end
end
