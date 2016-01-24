defmodule OtziSpace.Oauth.User do
  defstruct [:name, :bio, :uid, :website, :type,
             :profile_picture, :username, :access_token]
end
