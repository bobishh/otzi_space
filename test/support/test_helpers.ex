defmodule OtziSpace.TestHelpers do
  alias OtziSpace.Oauth
  alias OtziSpace.User
  alias OtziSpace.Repo
  alias Elixtagram.Model.User, as: ElixtagramUser

  def form_oauth_user do
    %Oauth.User{ name: "bogdan agafonov",
                 uid: "12312312312",
                 bio: "a well-known super guy. people call him `IT Jesus`",
                 profile_picture: "http://bull.shit/pic.jpg",
                 access_token: "X_ACCESS_TOKEN_X",
                 username: "bovoid",
                 website: "eternalvoid.com" }

  end

  def instagram_user do
    %ElixtagramUser{ bio: "", counts: %{followed_by: 90, follows: 110, media: 82},
                    full_name: "Bogdan Agafonov", id: "1210987030",
                    profile_picture: "https://scontent.cdninstagram.com/hphotos-ash/t51.2885-19/10623627_1538728483013520_390253157_a.jpg",
                    username: "bovoid", website: ""}
  end


  def create_user(oauth_user) do
    user_changeset = User.oauth_changeset(%User{}, %{ name: oauth_user.name,
                                                username: oauth_user.username,
                                                website: oauth_user.website,
                                                bio: oauth_user.bio,
                                                profile_picture: oauth_user.profile_picture,
                                                password: "testpass"
                                              })
    Repo.insert(user_changeset)
  end
end
