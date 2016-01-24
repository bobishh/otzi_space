defmodule OtziSpace.Oauth.UserFetcher do
  alias OtziSpace.Oauth
  # @moduledoc
  # fetches oauth user based on provider type
  def fetch_oauth_user(params) do
    case params["provider"] do
      "instagram" -> ask_instagram(params["code"])
      _ -> nil
    end
  end

  # fetches instagram user and access_token
  defp ask_instagram(code) do
    access_token = Elixtagram.get_token!(code: code).access_token
    Elixtagram.configure(:global, access_token)
    oauth_user = Elixtagram.user(:self, :global)
    { :ok, transform_instagram_user(oauth_user, access_token) }
  end

  defp transform_instagram_user(instagram_user, access_token) do
    %Oauth.User{name: instagram_user.full_name,
                username: instagram_user.username,
                profile_picture: instagram_user.profile_picture,
                type: "instagram",
                access_token: access_token,
                website: instagram_user.website,
                bio: instagram_user.bio,
                uid: instagram_user.id
               }
  end
end
