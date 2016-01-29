defmodule OtziSpace.LayoutView do
  use OtziSpace.Web, :view
  alias OtziSpace.Router.Helpers

  def login_or_logout(conn) do
    current_user = conn.assigns[:current_user]
    if current_user != nil do
      link("Logout", to: Helpers.session_path(conn, :delete, current_user), method: "delete")
    else
      link("Login", to: Helpers.session_path(conn, :new))
    end
  end

  def changeset_errors(changeset) do
    errors = changeset.errors
    for error <- errors do
      error_tag(error)
    end
  end

  def error_tag(error) do
    content_tag(:div, error_content(error), class: 'error')
  end

  def error_content(error) do
    key = Dict.keys(error)[0]
    value = error[key]
    "#{key} - #{value}"
  end
end
