defmodule Ksphoenix.Tasks do
  alias Ksphoenix.Repo
  alias Ksphoenix.Tasks.Task

  def list_tasks do
    Repo.all(Task)
  end

  def create_task(attrs) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end
end
