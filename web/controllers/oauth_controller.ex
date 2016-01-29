defmodule OtziSpace.OauthController do
  use OtziSpace.Web, :controller
  alias OtziSpace.Oauth
  alias OtziSpace.OauthResource
  import Phoenix.Controller
  import OtziSpace.Auth, only: [login: 2, init: 1]
  alias OtziSpace.Router.Helpers

  # oauth callback
  def auth(conn, params) do
    { :ok, oauth_user } = Oauth.UserFetcher.fetch_oauth_user(params)
    pick_action(conn, oauth_user)
  end

  defp pick_action(conn, oauth_user) do
    resource = Repo.one(from oar in OauthResource, where: oar.uid == ^oauth_user.uid and
                        oar.type == ^oauth_user.type, preload: :user)
    cond do
      user = !conn.assigns.current_user && resource && resource.user ->
        oauth_login(conn, user)
      resource && resource.user && resource.user != conn.assigns.current_user ->
        say_resource_taken(conn)
      user = !resource && conn.assigns.current_user ->
        tie_resource(conn, user, oauth_user)
      true ->
        say_not_found(conn)
    end
  end

  defp say_not_found(conn) do
    conn
    |> put_flash(:error, "User not found.")
    |> redirect(to: Helpers.session_path(conn, :new))
  end

  defp tie_resource(conn, user, oauth_user) do
    { :ok, resource } = Oauth.ResourceBuilder.create_resource(user, oauth_user)
    conn
    |> put_flash(:info, "#{resource.type} tied successfully.")
    |> redirect(to: Helpers.profile_path(conn, :index))
  end

  defp say_resource_taken(conn) do
    conn
    |> put_flash(:error, "Resource taken.")
    |> redirect(to: Helpers.profile_path(conn, :index))
  end

  defp oauth_login(conn, user) do
    conn
    |> login(user)
    |> put_flash(:info, "Welcome!")
    |> redirect(to: Helpers.page_path(conn, :index))
  end
end
