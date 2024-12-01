import Config

config :elixir, :time_zone_database, Tz.TimeZoneDatabase

config :advent_of_code, AdventOfCode.Input,
  allow_network?: true,
  session_cookie: System.get_env("AOC_COOKIE")

# If you don't like environment variables, put your cookie in
# a `config/secrets.exs` file like this:
#
# config :advent_of_code, AdventOfCode.Input,
#   allow_network?: true,
#   session_cookie: "..."

try do
  import_config "secrets.exs"
rescue
  _ -> :ok
end
