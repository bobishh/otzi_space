defmodule OtziSpace.SessionView do
  use OtziSpace.Web, :view

  def authorize_url do
    Elixtagram.authorize_url!()
  end

end
