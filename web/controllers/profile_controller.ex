defmodule OtziSpace.ProfileController do
  use OtziSpace.Web, :controller

  def index(conn, _params) do
    Elixtagram.configure
    url = Elixtagram.authorize_url!
    render(conn, "show.html", instagram_oauth_url: url)
  end

end
