defmodule Ksphoenix.TodosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ksphoenix.Todos` context.
  """

  @doc """
  Generate a todo.
  """
  def todo_fixture(attrs \\ %{}) do
    {:ok, todo} =
      attrs
      |> Enum.into(%{
        description: "some description",
        due_date: ~D[2024-12-12],
        is_completed: true,
        status: "some status",
        task_type: "some task_type",
        title: "some title"
      })
      |> Ksphoenix.Todos.create_todo()

    todo
  end
end
