defmodule OtziSpace.ArtistController do
  use OtziSpace.Web, :controller
  import Ecto.Query, only: [from: 2]
  alias OtziSpace.Repo
  alias OtziSpace.User
  alias OtziSpace.Role

  def index(conn, _params) do
    role = Repo.one(from r in Role, where: r.name == "artist", preload: :users)
    artists = role.users
    render(conn, "index.html", artists: artists)
  end

  def show(conn, %{"id" => id}) do
    artist = Repo.get(User, id)
    render(conn, "show.html" , artist: artist)
  end
end
