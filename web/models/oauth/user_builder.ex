defmodule OtziSpace.Oauth.UserBuilder do
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]
  alias OtziSpace.Repo
  alias OtziSpace.User

  def create_user(oauth_user) do
    user_changeset = form_changeset(oauth_user)
    Repo.insert(user_changeset)
  end

  defp form_changeset(oauth_user) do
    User.oauth_changeset(%User{}, %{name: oauth_user.name,
                              username: oauth_user.username,
                              profile_picture: oauth_user.profile_picture,
                              bio: oauth_user.bio,
                              website: oauth_user.website,
                              password: hashpwsalt(oauth_user.name)
                             })
  end

end
