import Config
config :ash, disable_async?: true

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :virtual_reality_yoga, VirtualRealityYoga.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "virtual_reality_yoga_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :virtual_reality_yoga, VirtualRealityYogaWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "ESIL/bTvRppm+Tz+anXWHRJMFSC9Ny4P8yqR8kUDLsXibI8aINA2y/W9dwg0Z47C",
  server: false

# In test we don't send emails
config :virtual_reality_yoga, VirtualRealityYoga.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
