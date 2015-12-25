defmodule OtziSpace.PageController do
  use OtziSpace.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
