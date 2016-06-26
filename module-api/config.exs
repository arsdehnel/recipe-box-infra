use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.

# You can generate a new secret by running:
#
#     mix phoenix.gen.secret
config :recipeboxapi, Recipeboxapi.Endpoint,
  secret_key_base: "Z29vZnkgdGhpbmcgbG9uZyB3b3JkcyB3aXRoIHNvbWUgbW9yZSB3b3JkcyBldmVyeXdoZXJl"

# Configure your database
config :recipeboxapi, Recipeboxapi.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "recipe_box",
  password: "fvnNRYMxEv0l290i",
  database: "recipe_box",
  hostname: "tf-ur6xxvd7tjaelda5qfmlijahfa.csbflrjl6b8q.us-west-2.rds.amazonaws.com",
  pool_size: 10
