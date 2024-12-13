defmodule Ksphoenix.Todos.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todos" do
    field :status, :string, default: "Pending"
    field :description, :string
    field :title, :string
    field :due_date, :date
    field :is_completed, :boolean, default: false
    field :task_type, :string, default: "Not Urgent &  Not Important"

    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:title, :description, :due_date, :status, :is_completed, :task_type])
    |> validate_required([:title, :description, :due_date, :status, :is_completed, :task_type])
  end
end
