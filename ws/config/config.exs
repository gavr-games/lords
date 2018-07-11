# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :lords_ws, LordsWs.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "JYYnVGGdClvzhC/UQoPTtq3YIyiZFWnSxiW3D39frW6077Fn1I4xXUz+3xObEps2",
  render_errors: [view: LordsWs.ErrorView, accepts: ~w(html json)],
  pubsub: [name: LordsWs.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger,
  backends: [:console, {LoggerFileBackend, :file_log}],
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :logger, :file_log, 
  path: "/var/log/ws/ws.log",
  level: :debug

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
