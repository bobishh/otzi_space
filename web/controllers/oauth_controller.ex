defmodule OtziSpace.OauthController do
  use OtziSpace.Web, :controller
  alias OtziSpace.Oauth
  alias OtziSpace.OauthResource
  import Phoenix.Controller
  import OtziSpace.Auth, only: [login: 2, init: 1]
  alias OtziSpace.Router.Helpers

  # oath callback
  def auth(conn, params) do
    { :ok, oauth_user } = Oauth.UserFetcher.fetch_oauth_user(params)
    { :ok, user } = find_or_create_user(oauth_user)
    conn
    |> login(user)
    |> redirect(to: Helpers.profile_path(conn, :index))
  end

  defp find_or_create_user(oauth_user) do
    resource = Repo.one(from oar in OauthResource, where: oar.uid == ^oauth_user.uid and
                        oar.type == ^oauth_user.type, preload: :user)
    if resource && resource.user do
      { :ok, resource.user }
    else
      { :ok, user } = Oauth.UserBuilder.create_user(oauth_user)
      Oauth.ResourceBuilder.create_resource(user, oauth_user)
      { :ok, user }
    end
  end

end
