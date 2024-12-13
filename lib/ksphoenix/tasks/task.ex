defmodule Ksphoenix.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :task, :string
    field :date, :date
    ield :status, :string, default: "pending"
    field :description, :string
    field :title, :string
    field :due_date, :date
    field :is_completed, :boolean, default: false
    field :task_type, :string

    timestamps()
  end

  def changeset(task, attrs) do
    task
    |> cast(attrs, [:task, :date])
    |> validate_required([:task, :date])
  end
end

  schema "tasks" do
    field :status, :string, default: "pending"
    field :description, :string
    field :title, :string
    field :due_date, :date
    field :is_completed, :boolean, default: false
    field :task_type, :string

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :description, :due_date, :status, :is_completed, :task_type])
    |> validate_required([:title, :description, :due_date, :status, :is_completed, :task_type])
  end
end
