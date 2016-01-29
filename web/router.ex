defmodule OtziSpace.Router do
  use OtziSpace.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug OtziSpace.Auth, repo: OtziSpace.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", OtziSpace do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/registrations/confirm", ConfirmationController, :confirm
    resources "/users", UserController
    resources "/artists", ArtistController
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/registrations", RegistrationController, only: [:new, :create, :delete]
    get "/profile", ProfileController, :index
    get "/auth", OauthController, :auth
  end

  # Other scopes may use custom stacks.
  # scope "/api", OtziSpace do
  #   pipe_through :api
  # end
end
