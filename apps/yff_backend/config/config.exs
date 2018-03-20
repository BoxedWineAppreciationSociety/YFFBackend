use Mix.Config

config :yff_backend, ecto_repos: [YFFBackend.Repo]

import_config "#{Mix.env}.exs"
