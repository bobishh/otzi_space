defmodule OtziSpace.ProfileView do
  use OtziSpace.Web, :view

  def get_current_user(conn) do
    case conn.assigns do
      %{ current_user: user } ->
        user
      _ -> nil
    end
  end

  def instagram_action_link(conn, url) do
    user = conn.assigns.current_user
    cond do
      user && user.oauth_resources == [] -> link("Add instagram", to: url)
      true -> link("Update instagram", to: url)
    end
  end
end
