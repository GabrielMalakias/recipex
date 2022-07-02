import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :recipex, RecipexWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "vuBo0p/YT+z3GZbnkH2zUhYimlTGMXgXGannaPieXzKzHnp9tS6kCKZWo3rkn+38",
  server: false

config :recipex, :contentful,
  space_id: "space_id",
  access_token: "access_token"

# In test we don't send emails.
config :recipex, Recipex.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
