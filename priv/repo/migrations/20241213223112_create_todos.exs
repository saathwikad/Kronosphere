defmodule Ksphoenix.Repo.Migrations.CreateTodos do
  use Ecto.Migration

  def change do
    create table(:todos) do
      add :title, :string
      add :description, :text
      add :due_date, :date
      add :status, :string, default: "Pending", null: false
      add :is_completed, :boolean, default: false, null: false
      add :task_type, :string

      timestamps()
    end
  end
end
