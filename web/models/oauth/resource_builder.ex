defmodule OtziSpace.Oauth.ResourceBuilder do
  alias OtziSpace.Repo

  def create_resource(user, oauth_user) do
    resource = Ecto.build_assoc(user, :oauth_resources, form_resource_attrs(oauth_user))
    Repo.insert(resource)
  end

  defp form_resource_attrs(oauth_user) do
    %{ name: oauth_user.name,
       type: oauth_user.type,
       username: oauth_user.username,
       uid: oauth_user.uid,
       access_token: oauth_user.access_token }
  end
end
