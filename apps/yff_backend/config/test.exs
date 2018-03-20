use Mix.Config

# Configure your database
config :yff_backend, YFFBackend.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "yff_backend_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
