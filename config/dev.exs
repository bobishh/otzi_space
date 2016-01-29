use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :otzi_space, OtziSpace.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  cache_static_lookup: false,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin"]],
  # Mailgun config
  mailgun_domain: "https://api.mailgun.net/v3/sandbox026092118ba742b6854b906c45a519ab.mailgun.org",
  mailgun_key: "key-e35639026128f4734e192d2456162e13"

# Watch static and templates for browser reloading.
config :otzi_space, OtziSpace.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

config :elixtagram,
  instagram_client_id: "e50d4820b01b4784839c74aa05efa08d",
  instagram_client_secret: "5129c2294e09465097dd4d8d09dae7a0",
  instagram_redirect_uri: "http://localhost:4000/auth?provider=instagram"

# Set a higher stacktrace during development.
# Do not configure such in production as keeping
# and calculating stacktraces is usually expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :otzi_space, OtziSpace.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "bogdan",
  password: "",
  database: "otzi_space_dev",
  hostname: "localhost",
  pool_size: 10
