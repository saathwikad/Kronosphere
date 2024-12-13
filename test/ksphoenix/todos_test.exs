defmodule Ksphoenix.TodosTest do
  use Ksphoenix.DataCase

  alias Ksphoenix.Todos

  describe "todos" do
    alias Ksphoenix.Todos.Todo

    import Ksphoenix.TodosFixtures

    @invalid_attrs %{status: nil, description: nil, title: nil, due_date: nil, is_completed: nil, task_type: nil}

    test "list_todos/0 returns all todos" do
      todo = todo_fixture()
      assert Todos.list_todos() == [todo]
    end

    test "get_todo!/1 returns the todo with given id" do
      todo = todo_fixture()
      assert Todos.get_todo!(todo.id) == todo
    end

    test "create_todo/1 with valid data creates a todo" do
      valid_attrs = %{status: "some status", description: "some description", title: "some title", due_date: ~D[2024-12-12], is_completed: true, task_type: "some task_type"}

      assert {:ok, %Todo{} = todo} = Todos.create_todo(valid_attrs)
      assert todo.status == "some status"
      assert todo.description == "some description"
      assert todo.title == "some title"
      assert todo.due_date == ~D[2024-12-12]
      assert todo.is_completed == true
      assert todo.task_type == "some task_type"
    end

    test "create_todo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Todos.create_todo(@invalid_attrs)
    end

    test "update_todo/2 with valid data updates the todo" do
      todo = todo_fixture()
      update_attrs = %{status: "some updated status", description: "some updated description", title: "some updated title", due_date: ~D[2024-12-13], is_completed: false, task_type: "some updated task_type"}

      assert {:ok, %Todo{} = todo} = Todos.update_todo(todo, update_attrs)
      assert todo.status == "some updated status"
      assert todo.description == "some updated description"
      assert todo.title == "some updated title"
      assert todo.due_date == ~D[2024-12-13]
      assert todo.is_completed == false
      assert todo.task_type == "some updated task_type"
    end

    test "update_todo/2 with invalid data returns error changeset" do
      todo = todo_fixture()
      assert {:error, %Ecto.Changeset{}} = Todos.update_todo(todo, @invalid_attrs)
      assert todo == Todos.get_todo!(todo.id)
    end

    test "delete_todo/1 deletes the todo" do
      todo = todo_fixture()
      assert {:ok, %Todo{}} = Todos.delete_todo(todo)
      assert_raise Ecto.NoResultsError, fn -> Todos.get_todo!(todo.id) end
    end

    test "change_todo/1 returns a todo changeset" do
      todo = todo_fixture()
      assert %Ecto.Changeset{} = Todos.change_todo(todo)
    end
  end
end
