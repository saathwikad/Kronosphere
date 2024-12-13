defmodule Ksphoenix.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :status, :string
    field :description, :string
    field :title, :string
    field :due_date, :naive_datetime
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :description, :due_date, :status])
    |> validate_required([:title, :description, :due_date, :status])
  end
end
