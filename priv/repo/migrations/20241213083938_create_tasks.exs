defmodule Ksphoenix.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :name, :string
      add :date, :date

      timestamps()
    end
  end
end
