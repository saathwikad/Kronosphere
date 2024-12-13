defmodule Ksphoenix.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ksphoenix.Tasks` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        date: ~D[2024-12-12],
        task: "some task"
      })
      |> Ksphoenix.Tasks.create_task()

    task
  end
end
