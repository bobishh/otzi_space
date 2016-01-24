defmodule OtziSpace.ProfileView do
  use OtziSpace.Web, :view

  def get_current_user(conn) do
    case conn.assigns do
      %{ current_user: user } ->
        user
      _ -> nil
    end
  end
end
