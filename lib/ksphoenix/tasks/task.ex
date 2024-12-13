defmodule Ksphoenix.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :task, :string
    field :date, :date

    timestamps()
  end

  def changeset(task, attrs) do
    task
    |> cast(attrs, [:task, :date])
    |> validate_required([:task, :date])
  end
end
