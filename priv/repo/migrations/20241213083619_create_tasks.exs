defmodule Ksphoenix.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :task, :string
      add :date, :date

      timestamps()
    end

    create index(:tasks, [:date])
  end
end
