use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :otzi_space, OtziSpace.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :elixtagram,
  instagram_client_id: "e50d4820b01b4784839c74aa05efa08d",
  instagram_client_secret: "5129c2294e09465097dd4d8d09dae7a0",
  instagram_redirect_url: "http://localhost:4000/auth?provider=instagram"

# Configure your database
config :otzi_space, OtziSpace.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "bogdan",
  password: "",
  database: "otzi_space_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
