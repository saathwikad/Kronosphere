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
        description: "some description",
        due_date: ~N[2024-12-11 08:50:00],
        status: "some status",
        title: "some title"
      })
      |> Ksphoenix.Tasks.create_task()

    task
  end

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        description: "some description",
        due_date: ~D[2024-12-12],
        is_completed: true,
        status: "some status",
        task_type: "some task_type",
        title: "some title"
      })
      |> Ksphoenix.Tasks.create_task()

    task
  end
end
