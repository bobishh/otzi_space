defmodule OtziSpace.Oauth.ResourceBuilder do
  alias OtziSpace.Repo

  def create_resource_changeset(user, oauth_user) do
    Ecto.build_assoc(user, :oauth_resources, form_resource_attrs(oauth_user))
  end

  def create_resource(user, oauth_user) do
    resource_changeset = create_resource_changeset(user, oauth_user)
    Repo.insert(resource_changeset)
  end

  def update_resource_changeset(resource, oauth_user) do
    Ecto.Changeset.change(resource, form_resource_attrs(oauth_user))
  end

  def update_resource(resource, oauth_user) do
    chset = update_resource_changeset(resource, oauth_user)
    Repo.update! chset
  end


  defp form_resource_attrs(oauth_user) do
    %{ name: oauth_user.name,
       profile_picture: oauth_user.profile_picture,
       type: oauth_user.type,
       username: oauth_user.username,
       uid: oauth_user.uid,
       access_token: oauth_user.access_token }
  end
end
