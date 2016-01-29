defmodule OtziSpace.ProfileController do
  use OtziSpace.Web, :controller
  import OtziSpace.Auth, only: [authenticate_user: 2]
  plug :authenticate_user

  def index(conn, _params) do
    url = Elixtagram.authorize_url!
    user = Repo.preload(conn.assigns.current_user, :oauth_resources)
    conn = assign(conn, :current_user, user)
    render(conn, "show.html", instagram_oauth_url: url)
  end
end
