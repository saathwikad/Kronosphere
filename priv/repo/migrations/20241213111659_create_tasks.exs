defmodule Ksphoenix.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :description, :text
      add :due_date, :date
      add :status, :string
      add :is_completed, :boolean, default: false, null: false
      add :task_type, :string

      timestamps()
    end
  end
end
