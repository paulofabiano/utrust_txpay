# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :utrust_txpay,
  ecto_repos: [UtrustTxpay.Repo]

# Configures the endpoint
config :utrust_txpay, UtrustTxpayWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "MBXVAFiC862E4L+aV7MnyLooJ3kP8kmnbT1uM+9SkOs/VO2KJ2ZVhSwGhCc6Qsy4",
  render_errors: [view: UtrustTxpayWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: UtrustTxpay.PubSub,
  live_view: [signing_salt: "g2BQwIVY"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
