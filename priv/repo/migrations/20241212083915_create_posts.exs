defmodule Ksphoenix.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :username, :string
      add :body, :string

      timestamps()
    end
  end
end
