defmodule Ksphoenix.Repo do
  use Ecto.Repo,
    otp_app: :ksphoenix,
    adapter: Ecto.Adapters.Postgres
end
